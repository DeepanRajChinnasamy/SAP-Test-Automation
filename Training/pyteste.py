import pytest
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys

@pytest.fixture(scope="session")
def browser():
    # Set up Chrome options
    chrome_options = Options()
    chrome_options.add_argument("--start-maximized")

    # Specify the path to the ChromeDriver
    chromediverpath = driver.service.path
    service = Service('/usr/local/bin/chromedriver')

    # Initialize the WebDriver instance
    driver = webdriver.Chrome(service=service, options=chrome_options)
    yield driver
    driver.quit()

def test_open_google(browser):
    # Use the browser fixture to access the WebDriver instance
    browser.get("https://www.google.com")
    assert "Google" in browser.title
    search_box = browser.find_element(By.NAME, "q")
    search_box.send_keys("Selenium WebDriver" + Keys.RETURN)
    assert "Selenium" in browser.page_source
