# Trending Repositories

This project is designed to load and display trending repositories from GitHub. It incorporates several key features:
- **Trending Repositories**: Fetches and displays a list of trending repositories from GitHub based on user-defined criteria.
- **Favorite Caching**: Allows users to mark repositories as favorites, with their state persisted using Core Data for offline access and management.
- **Search Functionality**: Supports search functionality with a debounced mechanism to ensure efficient and responsive querying.
- **Pagination**: Implements pagination to load additional repositories as the user scrolls, optimizing data retrieval and performance.

## General Architecture

The application is designed using the **MVVM (Model-View-ViewModel)** architecture to ensure a clean separation of concerns and maintainability.

- **Model**: Represents the data layer. In this app, the models include `Repository`, `Owner`, and `RepositorySearchResponse`. These models are used to handle and process data from the GitHub API and Core Data.
  
- **View**: Represents the user interface components. SwiftUI `View` structs like `HomeView`, `RepositoriesTab`, and `FavoritesTab` define how data is presented to the user.

- **ViewModel**: Acts as an intermediary between the View and the Model. It manages the state and business logic. For instance, `RepositoriesViewModel` and `RepositoryDetailsViewModel` handle fetching data, updating the UI, and interacting with the Core Data layer.

The application uses **async/await** for handling asynchronous operations, such as network requests and data fetching, providing a cleaner and more readable codebase compared to traditional callback-based approaches.

## Main Technical Choices

- **MVVM Architecture**: Ensures that the UI layer is separated from the business logic and data management. This separation facilitates easier testing and maintenance.
   
- **Async/Await**: Simplifies asynchronous code, making it more readable and easier to reason about compared to callback-based methods or Combine publishers.

- **Core Data**: Used for local storage and caching of favorite repositories. This allows for offline access and faster loading times for favorite items.

- **Networking**: Utilizes a `NetworkManager` class to handle API requests and responses, which is testable and injectable. The `GitHubService` class interacts with `NetworkManager` to fetch data from the GitHub API.

- **Testing**: 
   - **NetworkManager** is mockable for unit testing, allowing you to test various responses without making actual network requests.
   - **GitHubService** uses the injected `NetworkManager` to enable easy testing of network-related functionality.

## Bonus Implemented Features

1. **Custom Image Caching**:
   - Implemented custom caching for avatar images to avoid redundant downloads and improve performance.

2. **Responsive UI for Tablets**:
   - Designed and implemented a responsive user interface suitable for both phones and tablets using SwiftUI.

3. **Search Functionality**:
   - Added search feature to filter repositories and favorites in the lis.
   - The search feature supports dynamic filtering and updates the displayed results in real-time as users type.

4. **Debounced Search Functionality**:
   - Implemented a debounce mechanism in the search feature to improve performance and user experience.
   - The debounce feature prevents excessive API calls by delaying the search request until the user has paused typing for a specified interval.
   - This reduces the number of requests sent to the server, minimizes network load, and ensures that search results are more relevant and timely.
   - The search results update smoothly and efficiently, providing a responsive and fluid user experience.

5. **Offline Experience**:
   - Implemented clear user feedback and functionality when there is no internet connection.
   - The application provides informative messages and options for users to retry fetching data, with a smooth experience even when connectivity is intermittent or unavailable.

## Production Considerations

1. **Advanced Error Handling**: The basic error handling is in place, but more robust error handling and user feedback can be implemented, specialy loading next page failure handling.

2. **Unit Tests**: Comprehensive unit tests should be added for ViewModels, Managers, and UI components to ensure reliability and robustness.

3. **Custom Image Caching**: In the current implementation, Kingfisher is used for loading and caching images. 
   		- Kingfisher is effective for handling image caching, but for production.
   		- Bulding  custom image caching solution. Will allow for more control over caching policies and optimizations tailored to the specific needs of the application.
           
4. **Pagination Using `Link` Header**: Currently, pagination is implemented using the `per_page` & `per_page` in request parameter and `total_count` from the response to determine the number of pages and fetch additional results.Can improve it by**Extracting the `Link` header** from the API response to get the URL for the next page.

