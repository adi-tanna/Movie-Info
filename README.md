## Summary
Create a master-detail application that shows the top movies currently playing in US movie theaters.  The application needs to display a table of top movies with descriptions for each movie (title, release date, genre, image).  When a user clicks a movie row, the application will navigate to a details page showing additional details on the selected movie.

![Movie App](https://github.com/PivotusVentures/pv-interview-mobile/raw/master/exercise.png)

## Pre-requisites
Create an account with The Movie DB (https://www.themoviedb.org) and request a free developer API key to gain access the REST API for movies.  The account and registration is free and happens instantly.  

## API Calls
Documentation: https://developers.themoviedb.org/3/getting-started
Once you receive your key, you can make requests using the following base url. You will need to replace the api_key with your issued key.

https://api.themoviedb.org/3/movie/76341?api_key={api_key}

| Method        | EndPoint          |
| ------------- | -------------     |
| GET           | /movie/top_rated  |
| GET           | /movie/{movie_id} |


## Minimum Requirements
The mobile application needs to support iOS 10 running in a simulator.  The following are additional requirements and limitations for the developer:
-	Must use a UITableViewController for the list of movies
-	Must use a UINavigationController 
-	Must use Storyboards for the UI
-	Must use Apple classes for Networking (ie URLSession, URLRequest, etc) 
-	Application should have smooth scrolling and support Asynchronous image loading

You are free to be creative with the UI provided the above requirements hold true.  We are testing your knowledge of the basics and not your ability to find open source frameworks to solve the problem.

## Bonus
You should be able to complete this project in under 2 hours.  That said, if you would like to go above and beyond the minimum, you are free to add to base app any additional features you can think of.  Some examples include creating a filter by genre of the top movies playing, adding a movie search, and/or providing links to artist bio and displaying movies images on the detail view.

## Deliverables
- Clone the repo into your account and share the url to the repo
- Finally, quality code is important to us.  We will be evaluating your project and will expect you to demonstrate how you tested your app and what considerations should be included in a professional level app.
