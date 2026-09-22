# Sierra ILS Collection Development - High Count Holds Automated Report
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/python-%233670A0.svg?style=for-the-badge&logo=python&logoColor=ffdd54)

## Summary
**What it does:** This automated report flags all titles in the collection with eight or more holds.

**Impact:** Delivers a weekly automated report of trending titles to help Collection Development Librarians easily assess and optimize inventory levels.

## Features and Deliverables

**Automated Email:**
<img width="975" height="690" alt="High Count Holds Email" src="https://github.com/user-attachments/assets/0f1a392f-848e-474a-86b5-e17296e9e5c6" />

**Excel Report:**
<img width="1168" height="934" alt="High-Count-Holds" src="https://github.com/user-attachments/assets/715b98e2-2ae1-4446-a84c-99746e655080" />

<img width="1055" height="927" alt="High-Count-Holds" src="https://github.com/user-attachments/assets/89fee904-537f-435e-a32a-3f444c31c6d0" />


## Data Pipeline Architecture
This repository features an automated data pipeline that generates, formats, and distributes Excel reports via email. The system integrates Windows Task Scheduler, a Batch script, SQL, and Python to handle the end-to-end workflow without manual intervention. The automated process is fully productionized within a Windows environment.

**Workflow Overview:**

[Windows Task Scheduler] ──> [orchestrator.bat] ──> [main.py] ──> [Sub-modules & SQL] ──> [Report delivered to Email Inbox]

**Repository Contents & Security Note:**

To comply with data security policies, the core Python automation scripts have been omitted from this public repository. Instead, this repository provides:
- The SQL Data-Extraction Script: The exact logic used to pull and aggregate Sierra ILS production data.
- Manual Alternative: If you do not have an automated environment, you can run the provided SQL script manually in pgAdmin and export the results directly to a spreadsheet.

## Acknowledgments
The automated pipeline is built off the brilliant work of Gem Stone-Logan. For more information on implementing the automated system, please see her IUG presentations, [Automating Reports with Python.](https://www.gemstonelogan.com/presentations.html)
