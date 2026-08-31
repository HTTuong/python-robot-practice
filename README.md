# Robot Framework Automation

[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-7.4.2-000000?logo=robotframework&logoColor=white)](https://robotframework.org)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white)](https://python.org)
[![Tests](https://img.shields.io/badge/tests-20%20passed-brightgreen)](#test-coverage)

A keyword-driven test automation suite for [saucedemo.com](https://www.saucedemo.com) and a public REST API, built with **Robot Framework** and **Python**. Implements the same UI flows twice — once with **Browser Library** (Playwright-based) and once with **SeleniumLibrary** — as a deliberate side-by-side comparison of the two dominant automation stacks in the Robot Framework ecosystem.


---

## Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Running Tests](#running-tests)
- [Test Coverage](#test-coverage)
- [Architecture & Design Decisions](#architecture--design-decisions)
- [Author](#author)

---

## Overview

This project demonstrates Robot Framework's keyword-driven approach applied to both UI and API testing. Rather than treating Robot Framework as "just another Selenium wrapper," the suite is structured around reusable, composable keywords stored in resource files — the Robot Framework equivalent of a Page Object Model.

A core design goal was to compare **Browser Library** (Playwright-based, auto-waiting) against **SeleniumLibrary** (WebDriver-based, explicit-waiting) on identical scenarios, to build a first-hand understanding of the trade-offs between the two — knowledge directly relevant to teams that still run Selenium-based suites alongside newer tooling.

## Tech Stack

| Category | Tool |
|---|---|
| Test framework | [Robot Framework](https://robotframework.org) |
| Language | Python |
| UI automation (primary) | [Browser Library](https://robotframework-browser.org) (Playwright-based) |
| UI automation (comparison) | SeleniumLibrary |
| API testing | RequestsLibrary |
| Assertion/data helpers | Collections (built-in) |

## Getting Started

### Prerequisites
- Python 3.10+
- Node.js (required internally by Browser Library)

### Installation

```bash
git clone https://github.com/<your-username>/robot-framework-automation.git
cd robot-framework-automation

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt
rfbrowser init
```

## Running Tests

```bash
robot tests/                        # run the full suite
robot tests/login.robot             # run a single file
robot tests/cart_selenium.robot     # run the SeleniumLibrary comparison suite
robot --dryrun tests/               # validate syntax/keywords without opening a browser
```

## Running by Tag

```
robot --include smoke tests/        # fast feedback subset
robot --include regression tests/   # full regression suite
robot --include checkout tests/     # single feature area
```

### Viewing Reports

Robot Framework generates `log.html` and `report.html` after every run:

```bash
open log.html      # step-by-step execution log, screenshots on failure
open report.html   # pass/fail summary
```

## Test Coverage

| Suite | Scenarios |
|---|---|
| **Login** (Browser Library) | Valid login, invalid password, locked-out account |
| **Cart** (Browser Library) | Add N products (data-driven via custom keyword), remove product, badge state validation |
| **Sorting** | Price low→high, verified via Playwright's `:nth-match()` CSS extension |
| **API** (RequestsLibrary) | GET/POST/PUT/DELETE against a REST endpoint, query-param filtering, response validation via `FOR` loops |
| **Login / Cart** (SeleniumLibrary) | Same scenarios as above, re-implemented to compare explicit-wait handling against Browser Library's auto-wait |

**Total: 20 test cases**

## Architecture & Design Decisions

**Resource files as Page Objects.** UI locators and reusable actions live in `.resource` files, not inline in test cases — `Login As Standard User`, `Add N Products To Cart`, `Get Cart Badge Count` are composable keywords, mirroring the same separation-of-concerns achieved via Page Object classes in the companion Playwright framework.

**Two libraries, one suite of scenarios, by design.** Browser Library and SeleniumLibrary implement identical test cases side by side. The most significant finding: Browser Library inherits Playwright's auto-waiting on every action, while SeleniumLibrary requires explicit `Wait Until *` keywords — an assertion written without one is a real, reproducible source of flaky failures, not a theoretical concern.

**Typed keyword arguments.** Custom keywords use Robot Framework's `${arg: int}` type-conversion syntax (e.g. `Add N Products To Cart    [Arguments]    ${count: int}=1`) rather than relying on implicit string arguments — arithmetic on an unconverted argument fails at runtime, so type hints are treated as functional, not cosmetic.

**Native browser interference is a real test hazard.** SeleniumLibrary tests initially failed intermittently due to Chrome's own password-leak-detection popup intercepting clicks after login with a widely-shared demo password. Fixed by disabling the relevant Chrome preferences (`credentials_enable_service`, `profile.password_manager_leak_detection`) at browser launch — a reminder that headed-browser test runs can surface OS/browser-level UI that headless CI runs would never expose.

## Author

Tuong Hoang