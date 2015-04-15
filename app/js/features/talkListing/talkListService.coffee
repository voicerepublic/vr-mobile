angular.module("voicerepublic")

.factory "Talks", ->
    # Some fake talks provided by factory
    uploadPending = [
        {
          title: "Audio 1"
          img: "img/ionic.png"
          recordDate: "22.03.2015"
        }
        {
          title: "Audio 2"
          img: "img/ionic.png"
          recordDate: "22.03.2015"
        }
        {
          title: "Audio 3"
          img: "img/ionic.png"
          recordDate: "22.03.2015"
        }
        {
          title: "Audio 4"
          img: "img/ionic.png"
          recordDate: "22.03.2015"
        }
    ]
    uploaded = [
        {
          title: "Audio 5"
          img: "img/ionic.png"
          uploadDate: "23.03.2015"
          recordDate: "22.03.2015"
        }
        {
          title: "Audio 6"
          img: "img/ionic.png"
          uploadDate: "23.03.2015"
          recordDate: "22.03.2015"
        }
        {
          title: "Audio 7"
          img: "img/ionic.png"
          uploadDate: "23.03.2015"
          recordDate: "22.03.2015"
        }
        {
          title: "Audio 8"
          img: "img/ionic.png"
          uploadDate: "23.03.2015"
          recordDate: "22.03.2015"
        }
    ]
    toUpload: ->
        uploadPending

    uploadedBefore: ->
        uploaded