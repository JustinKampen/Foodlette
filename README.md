# Foodlette
Undecided on what to eat?
Foodlette randomly selects a restaurant to eat at, Russian Roulette style.

# Play
- The user selects a default or custom filter to play.
- The segmented control lets the user view default and custom filters.
- The + button will let the user create a custom filter to be played with parameters set by the user.
- The edit button lets the user delete custom filters.

# Create Filter
- Allows to user to create a new filter to be used.
- User can set the filter image, name, category, narrative and (min/max) ratings.
- Selects an image from the user's album (if allowed).
- The criteria is used when the filter is selected on the play screen.

# Restaurant Details
- Displays both restaurant details from Recents/Favorites and also displays the Foodlette winner.
- Foodlette winner is selected from a Yelp API request with parameters based on the filter selected. 
- Yelp API request will contain the information for 50 local businesses per the user's location.
- Foodlette winner is randomly selected from the 50 local businesses contained in the Yelp API pull.
- The selected winner's location is displayed on the map.

# Recents
- Based on the previous selected winners.
- Recent restaurants are filtered by date selected.
- Swipe left on a business to delete from the history.
- Tap heart icon to add restaurant to favorites.

# Favorites
- Displays restaurants that have been selected as a favorite.
- Favorite restaunts are used in the favorite filter.
- The favorite filter only selects restaurants that have been favorited.

# Developed With
- iOS 13.1
- xcode 11.0
- Swift 5.0
