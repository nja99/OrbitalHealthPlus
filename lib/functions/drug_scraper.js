const chromium = require('chrome-aws-lambda');
const puppeteer = require('puppeteer-core');
const admin = require('firebase-admin');

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    databaseURL: 'https://xxxxx.firebaseio.com'
});

const db = admin.firestore();

// Rate Limiting
const RATE_LIMIT_DELAY_MS = 1000;

exports.scrapeDrugs = async (req, res) => {
    const url = req.query.url;

    if (!url) { return res.status(400).send("URL is required"); }

    try {
        await rateLimit();
        console.time('scrapeDrugsTest');

        const browser = await startBrowser();
        const page = await browser.newPage();

        await navigateToURL(page, url);
        
        const firstResultHref = await getFirstResultHref(page);
        if (!firstResultHref) {
            await browser.close();
            return res.status(404).send("No Search Result Found");
        }

        await page.goto(firstResultHref, { waitUntil: 'domcontentloaded' });

        const drugData = await scrapePageData(page);
        await saveToFirestore(drugData);

        await browser.close();
        console.timeEnd('scrapeDrugsTest');
        res.status(200).json(drugData);
    } catch (error) {
        console.timeEnd('scrapeDrugsTest');
        res.status(500).send(error.toString());
    }
};

const rateLimit = async () => {
    console.log("Rate limiting...");
    await new Promise(resolve => setTimeout(resolve, RATE_LIMIT_DELAY_MS));
};

const startBrowser = async () => {
    console.log("Starting browser...");
    return chromium.puppeteer.launch({
        args: [
            ...chromium.args,
            '--disable-gpu',
            '--disable-dev-shm-usage',
            '--disable-setuid-sandbox',
            '--no-first-run',
            '--no-sandbox',
            '--no-zygote',
            '--single-process'
        ],
        defaultViewport: chromium.defaultViewport,
        executablePath: await chromium.executablePath,
        headless: chromium.headless
    });
};

const navigateToURL = async (page, url) => {
    console.log(`Navigating to URL: ${url}`);
    await page.goto(url, { waitUntil: 'networkidle2' });
};

const getFirstResultHref = async (page) => {
    const firstResultSelector = '[data-testid="search-result-link"]';
    try {
        await page.waitForSelector(firstResultSelector, { timeout: 1000 });
        return await page.$eval(firstResultSelector, element => element.href);
    } catch {
        return null;
    }
};

const scrapePageData = async (page) => {
    console.log("Scraping data...");
    return page.evaluate(() => {
        const getTextContent = (selector, context = document) => context.querySelector(selector)?.textContent.trim() || null;

        const data = {
            drugName: getTextContent('h1'),
            brandNames: [],
            drugType: null,
            drugPurpose: null,
            drugAdvice: null,
            drugDescription: null,
            sideEffects: [],
            url: window.location.href
        };

        // Extract Information from Advice Section
        const adviceSection = document.querySelector('[data-testid="markup"]');
        if (adviceSection) {
            const paragraphs = adviceSection.querySelectorAll('p');
            data.drugAdvice = Array.from(paragraphs).map(p => p.textContent.trim()).join('\n\n');
        }

        // Extract Information from About Section
        const aboutSection = document.querySelector('[id^="about-"]');
        if (aboutSection) {
            let content = [];
            let sibling = aboutSection.nextElementSibling;

            while (sibling && sibling.tagName !== 'H2') {
                if (sibling.tagName === 'P') {
                    content.push(sibling.textContent.trim());
                }
                sibling = sibling.nextElementSibling;
            }

            data.drugDescription = content.join('\n\n');
        }

        // Extract Information from Detail Table
        const detailTable = document.querySelector('table');
        if (detailTable) {
            const rows = detailTable.querySelectorAll('tbody tr');

            rows.forEach(row => {
                const rowHeader = getTextContent('td:nth-child(1) p', row);
                const rowContent = getTextContent('td:nth-child(2) p', row);

                if (rowHeader && rowContent) {
                    if (rowHeader.includes('Type of medicine')) {
                        data.drugType = rowContent;
                    } else if (rowHeader.includes('Used for')) {
                        data.drugPurpose = rowContent;
                    } else if (rowHeader.includes('Also called')) {
                        data.brandNames = rowContent.split(';').map(name => name.trim()).filter(name => name !== '');
                    }
                }
            });
        }

        // Extraction Information from Side-Effects Table
        const sideEffectsSection = Array.from(document.querySelectorAll('b')).find(anchor =>
            anchor.textContent.includes('What can I do if I experience this?'));

        if (sideEffectsSection) {
            let content = [];
            let sibling = sideEffectsSection.closest('tr').nextElementSibling;

            while (sibling && sibling.tagName !== 'H2') {
                if (sibling.tagName === 'TR') {
                    const cell = sibling.querySelectorAll('td');
                    if (cell.length > 0) {
                        content.push(cell[0].textContent.trim());
                    }
                }
                sibling = sibling.nextElementSibling;
            }
            data.sideEffects = content;
        }

        return data;

    });
};

const saveToFirestore = async (drugData) => {
    const docRef = db.collection('drugs').doc(drugData.drugName);
    await docRef.set({ drugData });
};
