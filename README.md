# RandomFacts (WIP)
IOS app that retrieves first sentence from random Wikipedia article and allows user to read more if interested, or shuffle.

When a user selects "Randomize", the background color will change, and the app retrieves a random article's id, title, image, description. The app will then show the title and the first sentence of the article's description.
If the user is interested in the article, the user can choose "Check Out" and will be redirected to the Wikipedia article page via in-app browser.
If the user is not interested, the user can choose "Randomize" again, and discover a new article.


## TODO:
- account for articles that contain periods within the first sentence, and avoid cutting off early
- adding images to article page
- fix padding in title field
- consider error cases
- general code cleanup
- investigate opening article in Wikipedia app if available
- keep history of previously randomized articles

## Random Article View
![Random Article](https://i.imgur.com/2Y9yiiI.png)

## In-App Article View
![In-App Browser](https://i.imgur.com/1HbDcVh.png)
