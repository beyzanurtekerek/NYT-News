# 🗞️ NYT News Mobile App

## Overview
This is a mobile news app built using Swift and UIKit that integrates the New York Times API. The app allows users to browse breaking news, explore recommendations, save news, and search for articles with an intuitive and elegant user interface.
## Features
Home Screen
-	Breaking News section with horizontally scrollable cards
-	Recommendations section with vertically scrollable articles
  
Search Page
-	Discover categories (e.g. Arts, Science, Sports)
-	Live search functionality for keywords
-	Displays results based on both categories and text input

Article Details
-	View detailed news content
-	Save articles for offline reading

Saved Articles
-	Dedicated page showing all saved articles
-	Option to unsave articles

## Technologies Used
- **Swift**: Core language for development
- **UIKit**: UI framework for creating views and layout
- **CoreData**: Used to persist saved articles
- **SDWebImage**: For efficient asynchronous image loading
- **MVVM Architecture**: Organizes code for maintainability
- **New York Times API**: Fetches article data (Top stories api and Article search api)
- **Auto Layout**: Ensures responsive UI on all device sizes

## Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/NYT-News.git  
   cd NYT-News  
2. Open the project in Xcode.
3. Install dependencies if not already present (e.g. SDWebImage)
4. Add your API key:
- Create a Config.plist file
- Add a key: NYT_API_KEY and paste your New York Times API key as its value
5. Run the app on a simulator or physical device

## API Setup
- Visit [NYT Developer Portal](https://developer.nytimes.com/)
- Create an account and generate an API Key
- Add the key to Config.plist under the key NYT_API_KEY

## Future Developments
- Implement bookmarking animations
- Add dark mode support
- Improve search suggestions and filters
- Localization for multiple languages
- Add live stock market information to the home page
- Create a User Login

## Screenshots
### 1. Feed, Detail and Read More Screen:
![feed-detail](https://github.com/user-attachments/assets/e1eb49be-c42a-4399-a4f6-e949bc92e692)

### 2. Search and Category Screen:
![search-category](https://github.com/user-attachments/assets/8e7326db-c5f0-4ba8-8537-a6cff7976bc4)

### 3. Save Functionality:
![save](https://github.com/user-attachments/assets/a88c37c2-167e-489e-b856-043d82b56d13)

### 4. Notifications and Unsave Function:
![notif-unsave](https://github.com/user-attachments/assets/e7408720-eaba-4536-9468-7c34f169fb98)

## API Enhancements
**The app utilizes two different endpoints from the New York Times API:**
- Top Stories API: for breaking news and category-based highlights
- Article Search API: for fetching detailed results based on user queries
 
**Improved Error Handling**
- Graceful fallback for empty states and API failures
- User-friendly error messages shown when no results are found
 
**Secure API Key Management**
- API keys are stored securely in Config.plist (excluded from version control)
- The app reads keys safely using a ConfigManager, preventing hardcoded secrets
 
**Model Compatibility**
- Data models conform to Codable, allowing smooth decoding of JSON responses
- Custom keys mapped using CodingKeys for precise control over JSON parsing
 
**Efficient Networking**
- URLSession-based APIService manages requests in a centralized and reusable way
- Async/await support for clean and modern asynchronous handling
 
**Scalability Consideration**
- Modular structure allows for easy addition of new NYT endpoints or APIs
- Error and success states are handled via enums to simplify response logic

















