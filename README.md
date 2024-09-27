# News
News app fetches news from Open news api - https://newsapi.org/
- App is been developed using Xcode 15.3 and minimum deployment version is 17.4
- App is written using Swift & Swift UI programming language and has been tested on Simulator, Core data is used for database.
- There are two tabs Headlines & Bookmarks tabs. Headlines tab displays top headlines news from server & Bookmark tab displays all bookmarked news articles.
- Headlines tab has filter icon at top right corner to select news category and fetch category wise news articles, Tapping again resets the selected news filter.
- Tapping on news item displays detailed news view, where user can click on top right icon to boomark the article & tapping back again removes item from bookmark list.
- Bookmarked article are saved using core database.

- Note: Guide to run the project,
Download the project and run on simulator / device.
In case of database related error, delete "NewsArticle" db from xcode project and add it again from News project folder.
No internet conditions can be verified on actual device, On simulator it does responds well.
![TopHeadlines](https://github.com/user-attachments/assets/24725b72-4614-4aab-8bbc-189e3dcdddfa)
![BookmarkedNews](https://github.com/user-attachments/assets/2a12545e-530e-4749-bf20-016756ac74d7)
![NewsDetails](https://github.com/user-attachments/assets/1edfaa59-77db-4738-abff-119010e28d46)
