# Project 1 - *Flicks*

**Flicks** is a movies app using the [The Movie Database API](https://developers.themoviedb.org/3).

Time spent: **TBD** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [x] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] Implemented a homepage shortcut using 3D touch. User can choose to view 'now playing' movies. This will be build out more as I build more categories into Flicks.
- [x] Add Icon images to the app.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. When to use storyboard and when to implement programmatically?
2. Correct way to store api keys.
3. Multithreading & updating on the main thread

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='FlicksDemo.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

1. I took a good bit of time trying to figure out where to put the UIView that shows the network error message on the story board so it appears at the top of the screen but does not push the first cell down in the table view. 

2. Still learning Swift syntax

## License

    Copyright [2016] [William Huang]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
