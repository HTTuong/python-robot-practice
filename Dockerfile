FROM --platform=linux/amd64 python:3.11-slim

# Install Node.js — Browser Library needs Node to run Playwright driver
RUN apt-get update && apt-get install -y curl gnupg wget \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome — SeleniumLibrary need a real browser, Selenium Manager can run chromedriver
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install browser binaries for Browser Library
RUN rfbrowser init

COPY . .

CMD ["sh", "-c", "robot --outputdir results tests/ || (echo 'Some tests failed - retrying failed tests once...' && robot --outputdir results --rerunfailed results/output.xml --output results/output.xml tests/)"]