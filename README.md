# Cloud Resume Challenge (Azure Edition)
- This project involves hosting a a static website on Azure Storage which shows view count everytime someone loads the website. It also includes GitHub Actions pipeline for continuous integration and deployment.
- You can access the website [here](http://qrcode.ebamforesume.cloud).

## Features
- **Static Web Resume:** A professional resume built with HTML/CSS and hosted using Azure Blob Storage.
- **Visitor Counter:** A live counter that tracks the number of visitors using Azure Functions and Cosmos DB.
- **Infrastructure as Code:** Automating infrastructure deployment using Terraform.
- **CI/CD Pipeline:** Automating deployment workflows using GitHub Actions.
- **Serverless Backend:** Using Azure Functions to process visitor interactions without managing servers.

## Tech Stack
- **Languages:** HTML, CSS, Python, Javascript.
- **Cloud Services:** Azure Blob Storage, Azure CDN, Azure Function App, Azure DNS Zone, Azure Key Vault, Azure Cosmos DB, Azure Application Insights>
- **Infrastructure-as-Code**: Terraform.
- **API Test:** Cypress.
- **CI/CD:** Github Actions.

## Project Details
#### 1. Static Web Resume(Frontend)
This is created using HTML with CSS for styling. There is a GET request which made when the website is opened to Azure Functions App endpoint `https://func-pers-prod-01.azurewebsites.net/api/HttpTrigger3`.
Two HTML files are hosted on Azure Blob Storage; resume.html which shows the resume webpage. and error.html which displays when resume.html isnt available. The website has a SSL certificated generated using Lets Encryptv which is regenerated every 3 months.

#### 2. Visitor Counter
This is a python based API created as a serverless function with Azure Functions App. The funtion app is triggered by an HTTP trigger when a GET request is made. The API updates the request count in a database created using Azure Cosmos DB and returns updated count to the website for view. Cross-Origin Resource Sharing (CORS) is enabled on the function app for restricted access.

#### 3. Cloud Infrastructure
The cloud infrastructure(Azure Blob Storage, Azure Functions App, Azure DNZ Zone, Azure Key Vault) was first created using Azure Portal to gain more familiarity with Azure Portal Usage. It was then imported into Terraform using aztfexport for management and subsequent changes.
The Azure infrastructure consists of the following key services:
- **Azure Blob Storage:** This is used to host the .html files.
- **Azure Functions App:** This hosts the API endpoint which updates the view count.
- **Azure DNS Zone:** This stores the DNS records of the application and also for the azure subscription
- **Azure Cosmos DB:** This is used to store the website view count.
- **Azure Key Vault:** This is used to store SSL certificate generated by Lets Encrypt.
- **Azure CDN:** This was used in order to attach a custom domain to the Azure Blob Storage web endpoint.
- **Azure Applications Insight:** This gathers performwance data from the Azure Functions App.
- **Azure Monitor:** This is used to provide alerts based on Application Insights. Two alerts are created; when more than 50 requests are made over a 5 minutes span and when 10 API requests fail over a 5 minutes span.

#### 4. CI/CD Pipeline
Github Actions is used to handle the CI/CD section of the code. There are 3 GitHub Actions workflow files.
1. **frontend-ci-cd.yml:** 
    * This GitHub Actions workflow is triggered by a push to the main branch, specifically when files in the frontend/ directory are modified. It performs several tasks to deploy a website to Azure Blob Storage. First, the workflow checks out the code and logs into Azure using credentials stored in GitHub Secrets. It then removes unnecessary files like README.md, .git, and .github from the frontend/ directory to clean up the content before deployment. Next, it uploads the cleaned frontend content to an Azure Blob Storage account, overwriting the existing files in the $web container. After that, the workflow purges the Azure CDN endpoint cache to ensure the latest version of the website is served. Finally, it logs out from Azure to securely end the session.

2. **api-test-with-cypress.yml:**
    * This GitHub Actions workflow is triggered by pull requests to the main branch when changes are made in the python-api/ directory (excluding infra-prod/ and infra-staging/). The workflow has several jobs that automate the deployment and testing of an Azure Function App.
    * First, the create-test-infra job sets up a test infrastructure using Terraform and retrieves outputs like resource group names, app names, and API endpoints. The deploy-azure-api-merge-request job then deploys the Python Azure Function App to the newly created infrastructure, installing dependencies and ensuring the app is properly deployed. If the deployment fails, the infrastructure is automatically deleted.
    * Next, the cypress-api-endpoint-test job runs Cypress end-to-end tests against the deployed API using the generated endpoint. Finally, the if_merged job ensures that the test infrastructure is deleted once the tests are complete, whether the pull request is merged or not. This workflow ensures automated deployment, testing, and cleanup for changes to the Python API codebase.

3. **azure-deploy-merged-code.yml:**
    * This GitHub Actions workflow automates the deployment of merged code to Azure Functions when a pull request is closed. It checks if the pull request was merged and, if so, runs on an Ubuntu environment. The workflow begins by checking out the code and logging into Azure using credentials stored in GitHub Secrets. It then sets up a Python environment with the specified version (3.9). The workflow resolves project dependencies by installing them from a requirements.txt file into a designated directory. Finally, it deploys the application to Azure Functions using the Azure Functions Action, leveraging a publish profile stored in GitHub Secrets to handle the deployment process.









