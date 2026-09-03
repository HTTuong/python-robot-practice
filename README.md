# Robot Framework Automation

[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-7.4.2-000000?logo=robotframework&logoColor=white)](https://robotframework.org)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB?logo=python&logoColor=white)](https://python.org)
[![Tests](https://img.shields.io/badge/tests-31%20passed-brightgreen)](#test-coverage)

A keyword-driven test automation suite for [saucedemo.com](https://www.saucedemo.com) and a public REST API, built with **Robot Framework** and **Python**. Implements the same UI flows twice, once with **Browser Library** (Playwright-based) and once with **SeleniumLibrary**, as a deliberate side-by-side comparison of the two dominant automation stacks in the Robot Framework ecosystem. Also includes API-level load testing with **k6**.


---

## Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Running Tests](#running-tests)
- [Running by Tag](#running-by-tag)
- [Parallel Execution](#parallel-execution)
- [Load Testing](#load-testing)
- [Running with Docker](#running-with-docker)
- [CI/CD](#cicd)
- [Test Coverage](#test-coverage)
- [Architecture & Design Decisions](#architecture--design-decisions)
- [Author](#author)

---

## Overview

This project demonstrates Robot Framework's keyword-driven approach applied to both UI and API testing. Rather than treating Robot Framework as "just another Selenium wrapper," the suite is structured around reusable, composable keywords stored in resource files, the Robot Framework equivalent of a Page Object Model.

A core design goal was to compare **Browser Library** (Playwright-based, auto-waiting) against **SeleniumLibrary** (WebDriver-based, explicit-waiting) on identical scenarios, to build a first-hand understanding of the trade-offs between the two, knowledge directly relevant to teams that still run Selenium-based suites alongside newer tooling. The suite also includes a **k6** load test against the API layer, reflecting the performance-testing dimension of QA work beyond pure functional automation.

## Tech Stack

| Category | Tool |
|---|---|
| Test framework | [Robot Framework](https://robotframework.org) |
| Language | Python |
| UI automation (primary) | [Browser Library](https://robotframework-browser.org) (Playwright-based) |
| UI automation (comparison) | SeleniumLibrary |
| API testing | RequestsLibrary |
| Assertion/data helpers | Collections (built-in) |
| Parallel execution | Pabot |
| Load testing | [k6](https://k6.io) |
| Containerization | Docker (Python + Node.js + Chrome in one image) |
| CI/CD | GitHub Actions |

## Getting Started

### Prerequisites
- Python 3.10+
- Node.js (required internally by Browser Library)
- [k6](https://k6.io) (for load testing)

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

```bash
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

## Parallel Execution

```bash
pabot tests/                        # split by suite (default)
pabot --testlevelsplit tests/       # split by individual test case
```

Screenshot directories are left unmanaged (not hardcoded to a shared path) so concurrent Pabot processes never write to the same file simultaneously.

## Load Testing

```bash
k6 run load-tests/api-load-test.js
```

Runs a virtual-user load profile against the REST API layer (ramping stages, configurable VUs/duration) with pass/fail thresholds on `p(95)` response time and error rate, the same signal a CI pipeline would use to block a deploy on performance regression.

## Running with Docker

```bash
docker compose up --build
```

Chrome runs headless automatically inside the container via the `HEADLESS` environment variable. The image bundles Python, Node.js, and Chrome together, since Browser Library requires Node internally while SeleniumLibrary drives Chrome directly.

## CI/CD

GitHub Actions builds the Docker image and runs the full suite inside it on every push to `main`. Failed tests are automatically re-run once (`--rerunfailed`) to absorb network-related flakiness when testing against the live public demo target, rather than masking genuine functional bugs, see [Architecture & Design Decisions](#architecture--design-decisions) for how that distinction was established.

## Test Coverage

| Suite | Scenarios |
|---|---|
| **Login** (Browser Library) | Valid login, invalid password, locked-out account |
| **Login Data-Driven** | Same scenarios via Robot Framework's `Test Template`, each data row reports as its own named test case |
| **Cart** (Browser Library) | Add N products (data-driven via custom keyword), remove product, badge state validation |
| **Checkout** | Happy path, multi-dataset validation (`[Template]`), missing-field negative case |
| **Sorting** | Price low→high, name A→Z/Z→A |
| **API** (RequestsLibrary) | GET/POST/PUT/PATCH/DELETE, nested-object assertions, query-param filtering, response validation via `FOR` loops |
| **Login / Cart** (SeleniumLibrary) | Same UI scenarios, re-implemented to compare explicit-wait handling against Browser Library's auto-wait |
| **Load test** (k6) | API response time (`p(95)`) and error-rate thresholds under ramping virtual-user load |

**Total: 31 test cases** (Robot Framework suite) + 1 k6 load test script

## Architecture & Design Decisions

**Resource files as Page Objects.** UI locators and reusable actions live in `.resource` files, not inline in test cases, `Login As Standard User`, `Add N Products To Cart`, `Get Cart Badge Count` are composable keywords, mirroring the same separation-of-concerns achieved via Page Object classes in the companion Playwright framework.

**Two libraries, one suite of scenarios, by design.** Browser Library and SeleniumLibrary implement identical test cases side by side. The most significant finding: Browser Library inherits Playwright's auto-waiting on every action, while SeleniumLibrary requires explicit `Wait Until *` keywords, an assertion written without one is a real, reproducible source of flaky failures, not a theoretical concern.

**Typed keyword arguments.** Custom keywords use Robot Framework's `${arg: int}` type-conversion syntax (e.g. `Add N Products To Cart    [Arguments]    ${count: int}=1`) rather than relying on implicit string arguments, arithmetic on an unconverted argument fails at runtime, so type hints are treated as functional, not cosmetic.

**Native browser interference is a real test hazard.** SeleniumLibrary tests initially failed intermittently due to Chrome's own password-leak-detection popup intercepting clicks after login with a widely-shared demo password. Fixed by disabling the relevant Chrome preferences (`credentials_enable_service`, `profile.password_manager_leak_detection`) at browser launch.

**Headless mode variant matters, and isn't obvious.** Dockerized SeleniumLibrary tests initially failed with clicks silently having no effect on the page, traced to Chrome's legacy `--headless=old` mode not reliably dispatching input events to a React-rendered UI after a DOM re-render. Switching to `--headless=new` (the modern rendering pipeline, shared with headed Chrome) resolved it completely. This was diagnosed by systematically ruling out other candidates (CPU architecture, sandboxing, timeouts) using CI screenshots as evidence at each step, rather than assuming the first plausible explanation.

**SPA hydration races are a distinct failure mode from slow networks.** A separate intermittent failure (`Element with locator 'id=user-name' not found'`) occurred because Selenium's `Open Browser` considers navigation "done" once the browser's `load` event fires, which, for a React app, can happen before the JS framework has actually rendered interactive content into the DOM. Fixed with an explicit `Wait Until Element Is Visible` immediately after opening the browser, closing the race window between "page loaded" and "app interactive."

**Remaining flakiness is handled via CI-level retry, not code changes.** After fixing the two functional bugs above, occasional timing-sensitive failures remained when running against the live saucedemo.com over the network on shared CI runners. Rather than continuing to tune timeouts indefinitely, this is handled with `--rerunfailed` at the CI level, the same category of solution used for Playwright's own `retries` configuration, and standard practice for browser automation against a live, non-mocked target.

## Author

Tuong Hoang