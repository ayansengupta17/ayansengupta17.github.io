---
title: "Toxic Comment Classification into red, yellow and green zones<br> <br><img src='/images/project-4/images/teaser.jpg'>"
excerpt: "In this project, deep learning method involving Bidirectional LSTM is used for the model for classifying toxic comments.
The same has been deployed as a web app on Heroku using Flask framework and an API has been created for it. "
header:
  image: project-4/header.gif
collection: projects
author_profile: true
---


### The Idea:
Discussing things you care about can be difficult. The threat of abuse and harassment online means that many people stop expressing themselves and give up on seeking different opinions. Platforms struggle to effectively facilitate conversations, leading many communities to limit or completely shut down user comments.
So we are working on tools to help improve online public conversation. One area of focus is the study of negative online behaviours, like toxic comments (i.e. comments that are rude, disrespectful or otherwise likely to make someone leave a discussion). So we are trying to detect different types of toxic comments. We are using a dataset of comments from Wikipedia’s talk page edits. Hopefully, this will help online discussion become more productive and respectful.
### Quickstart:
A basic comment classification model has been designed and currently hosted in Heroku's free servers. Currently, two methods are available for the testing and usage of the model.

* **Web interface**: A web interface for our model is hosted in Heroku and an example is shown below. One can query a text in the search field and the result would be shown there only. Integration of this with other platforms is not the goal for this setup. It is only for a demonstration and testing purpose. For integrating with varied platforms, we have a simple API structure that will ease integration. Check out the web interface at [link](https://comclassify.herokuapp.com/handle_data)
![web interface](/images/project-4/images/2.png "https://comclassify.herokuapp.com/handle_data")

* **API support**: Another web app has been deployed in Heroku which supports JSON requests. An example python code is given below which will fetch the result in a JSON format. The URL for the request is [https://rev-ai.herokuapp.com/result](https://rev-ai.herokuapp.com/result). One can integrate this with any platform for smooth and continuous queries.
![web interface](/images/project-4/images/3.png "rev-ai.herokuapp.com")



## Model:

The model is a Deep learning model using Bidirectional LSTMs. Though this model is in the alpha version It works with an accuracy of 97% on the test data. As we get more data we will keep training it and make it more robust.
## Output:
The model gives outputs in probabilities of toxicity level. Depending upon those probabilities we have currently created three broad spectrums namely the red zone, the yellow zone, the green zone. The red zone signifies that the model prediction shows a very high probability of a toxic comment. Green zone signifies safe comments, and the yellow zone is somewhere in between.

 Depending upon these zones the administrator of the platform may take an educated decision, for example, the red zone comments might be deleted, or the user might be flagged for offensive literature. Now for the yellow zone, one may flag the comments for manual review or let them pass. The comments for the green zone may be ignored.

Special caution has been taken such that a safe and non-toxic comment are not classified in the red zone. But on rare occasions, some text with offensive words may get a leeway and land up in the green zone.

Further in future, the actual probabilities for each query will be provided to the platforms who will use our model. In that case, the platforms will have an extra benefit of customizing the classification of sentences in their own ways.


**NOTE**:
Since free servers of Heroku platforms are currently in use, multiple queries may take time for processing.


