![feature graphic](https://user-images.githubusercontent.com/75874394/192554328-370aece6-9697-4878-92b8-eb120d07e1b1.png)
<br />

# OneStop : IIT Guwahati campus application
#### OneStop is developed wih motivation of assisting IIT Guwahati students in daily life utilities like Academic timetable, Food menus, Bus/Ferry timings and more. Students' Web Committee took the lead for this product, involved in its development from ideation, user research to deployment and release.

## Download Links
#### [Follow for PlayStore](https://play.google.com/store/apps/details?id=com.swciitg.onestop2) || [Follow for AppStore](https://apps.apple.com/in/app/onestop-iitg/id1642792642)

## 🧩 Main Features
#### <ul>
<li>Bus/Ferry schedule</li>
<li>Lost/Found items reporting</li>
<li>Buy/Sell items listing service</li>
<li>Contacts to vital administrative sections.</li>
<li>Cab sharing to share cab expenses</li>
<li>Food outlets and hostel messes updated menu</li>
<li>Separate categories under Buy & Sell</li>
<li>Dynamic scoreboard for Inter-hostel competitions</li>
<li>Mobile notifications for multiple services</li>
</ul>

## 💻 TechStack Used
#### <ul>
<li>Node.js</li>
<li>Express.js</li>
<li>Docker</li>
<li>Firebase - Cloud messaging</li>
<li>MongoDB</li>
</ul>

## 💻 Additional services used
#### <ul>
<li>Microsoft outlook authentication - Microsoft Azure</li>
<li>Cloud Messaging API for mobile notifications - Google Firebase</li>
<li>Continous deployment workflow - Github Actions</li>
</ul>

## 🍁 Mobile Application
- Follow [this link](https://github.com/swciitg/onestop_flutter) to app codebase repository.


## App views
<div align="center">
  <img src="./public/screenshots/home-page.png" alt="Image 1" width="200" />
  <img src="./public/screenshots/food-page.png" alt="Image 1" width="200" />
  <img src="./public/screenshots/profile-setup.png" alt="Image 2" width="200" />
  <img src="./public/screenshots/academic-timetable.png" alt="Image 3" width="200" />
</div>

## Setting up project on your machine ⚙️
- [Follow this guide](https://swciitg.notion.site/Day-1-f6ea19b1d7ff410e8ec03683772f4cd0) to setup Android Studio & Flutter SDK on your machine

## 🎪 Running application

1. **Prerequisites:**
   - Node.js installed on your machine.
   - A `.env` file containing environment variables.
   - push-notification-key json secret file of firebase application

</br>

2. **Environment variables inside .env:**
    - BASE_URL=/onestop/api/
    - PORT=9010
    - API_URL=https://localhost:3000/onestop/api
    - DATABASE_URI=YOUR_MONGODB_URI
    - MICROSOFT_GRAPH_CLIENT_ID=FROM AZURE ACTIVE DIRECTORY
    - OUTLOOK_CLIENT_ID=FROM AZURE ACTIVE DIRECTORY
    - OUTLOOK_CLIENT_SECRET=FROM AZURE ACTIVE DIRECTORY
    - MICROSOFT_GRAPH_CLIENT_SECRET=FROM AZURE ACTIVE DIRECTORY
    - MICROSOFT_GRAPH_TENANT_ID=FROM AZURE ACTIVE DIRECTORY
    - SECURITY_KEY=HEADERKEY
    - ACCESS_JWT_SECRET=YOUR_JWT_SECRET
    - REFRESH_JWT_SECRET=YOUR_REFRESH_JWT_SECRET
    - MODERATOR_KEY=SWC_ADMIN_MODERATOR
   - ADMIN_PANEL_COOKIE_SECRET="CookieSecret"

</br>

2. **Clone the Repository:**
   ```bash
   git clone https://github.com/swciitg/one-stop-2021.git
   cd one-stop-2021

3. **Install packages and start express server:**
   ```bash
   npm install && node app.js


# 🎨 Design

- We choose Node.js & Express.js for building backend APIs and have used various npm packages.
- Followed [MVC (Model View Controller) Architecture](https://www.w3schools.in/mvc-architecture) for separtion of different components and scaling can be done easily and [best practices](https://github.com/goldbergyoni/nodebestpractices) on backend.
- Used [MongoDB](https://www.mongodb.com) database which is a very popular No-SQL & scalable database in market.
- Followed proper [folder structure & best practices](https://www.geeksforgeeks.org/flutter-file-structure/) to develop different components on application side.
- Why built separate backend service instead of integrating services like [Firebase](https://firebase.google.com/) ?
    - Integrating Firebase SDK in Flutter causes the app to perform slow compared to directly making API requests to your server.
    - Also, now application & backend's code remain separated and development can be done easily, scaling application & backend side.
    - Most modern applications follow same practice of separating their different services.
- How Staging environment works ?
    - We have setup a CD pipeline on dev branch and with push, the changes are deployed on our staging server.
    - We perform proper testing for each release and then, merge dev into main branch for publishing our changes to production.

# 🧛 Future Advancements
- Shift to Typescript instead of Javascript because of various advantages.
- Refactor existing code for various features.
- Integrated test-cases for future releases.
- Generate API documentation using tools like Swagger.

# 🐛 Bug Reporting
#### Feel free to [open an issue](https://github.com/swciitg/one-stop-2021/issues) on GitHub if you find any bug.

<br />

# ⭐ Feature Suggestion
#### Feel free to [open an issue](https://github.com/swciitg/one-stop-2021/issues) on GitHub if you have feature idea to be added 🙌.
