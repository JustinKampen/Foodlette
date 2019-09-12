# Foodlette
Undecided on what to eat?
Foodlette randomly selects a restaurant to eat at, Russian Roulette style.

# Play Foodlette
- The user selects the Random button, 4+ Rating button or a filter to play.
- The + button will let the user create a new filter to be played with parameters set by the user.
- The history button displays the previous selected winners.
- The edit button lets the user delete filters.

# Foodlette Winner
- Foodlette winner is selected from a Yelp API request with parameters based on the filter selected. 
- Yelp API request will contain the information for 50 local businesses per the user's location.
- Foodlette winner is randomly selected from the 50 local businesses contained in the Yelp API pull.
- The selected winner's location is displayed on the map.

# Foodlette History
- Based on the previous selected winners.
- Winners are filtered by date selected.
- Swipe left on a business to delete from the history.

# Add Filter
- Allows to user to create a new filter to be used.
- User can set the filter image, name, category and ratings.
- The criteria is used when the filter is selected.

# Developed With
- iOS 12.2
- xcode 10.12.1
- Swift 5
