# Building a Chat App with EnableX iOS Toolkit: A Sample Application Guide

A Video Chat App with EnableX iOS Toolkit

This Sample Video-iOS-chat Application is the one-stop solution for building robust real-time chat applications on iOS devices. Using EnableX's Video APIs (https://developer.enablex.io/docs/references/apis/video-api/index/) and iOS Toolkit (https://developer.enablex.io/docs/references/sdks/video-sdk/ios-sdk/index), this sample iOS application simplifies the complexities of integrating real-time communication (RTC) into your mobile apps.

Key Features
Virtual Room Creation: This application dynamically creates a virtual room on EnableX’s cloud platform using REST API calls.
Multi-User Compatibility: Share the Room ID to invite others for a seamless RTC experience.
Quick Testing Environment: The app comes pre-configured to work with EnableX's hosted application server for quick testing.

> EnableX Developer Center: https://developer.enablex.io/

## 1. How to get started

### 1.1 Prerequisites

#### 1.1.1 App Id and App Key 

* Register with EnableX [https://portal.enablex.io/cpaas/trial-sign-up/] 
* Create your Application
* Get your App ID and App Key delivered to your email


#### 1.1.2 Sample iOS Client 

* Clone or download this Repository [https://github.com/EnableX/Sample-iOS-Chat.git] 


#### 1.1.3 Test Application Server

You need to set up an Application Server to provision Web Service API for your iOS Application to enable Video Session. 

To help you to try our iOS Application quickly, without having to set up Application Server, this Application is shipped pre-configured to work in a "try" mode with EnableX hosted Application Server i.e. https://demo.enablex.io. 

Our Application Server restricts a single Session Duations to 10 minutes, and allows 1 moderator and not more than 1 participant in a Session.

Once you tried EnableX iOS Sample Application, you need to set up your own  Application Server and verify your Application to work with your Application Server.  Refer to point 2 for more details on this.


#### 1.1.4 Configure iOS Client 

* Open the App
* Go to VCXConstant.swift and change the following:
``` 
 /* To try the App with Enablex Hosted Service you need to set the kTry = true
 When you setup your own Application Service, set kTry = false */
 let kTry = true

 /* Your Web Service Host URL. Keet the defined host when kTry = true */
 let kBasedURL = "https://demo.enablex.io/"
     
 /* Your Application Credential required to try with EnableX Hosted Service
 When you setup your own Application Service, remove these */
 let kAppId    = ""
 let kAppkey   = ""
 ```
 
 Note: The distributable comes with demo username and password for the Service. 

### 1.2 Test

#### 1.2.1 Open the App

* Open the App in your Device. You get a form to enter the Credentials i.e. Name & Room Id.
* You need to create a Room by clicking the "Create Room" button.
* Once the Room Id is created, you can use it and share with others to connect to the Virtual Room to carry out an RTC Session either as a Moderator or a Participant (Choose applicable Role in the Form).

Note: Only one user with Moderator Role allowed to connect to a Virtual Room while trying with EnableX Hosted Service. Your Own Application Server can allow upto 5 Moderators.

  
## 2. Set up Your Own Application Server

You can set up your own Application Server after you tried the Sample Application with EnableX hosted Server. We have differnt variants of Appliciation Server Sample Code. Pick the one in your preferred language and follow instructions given in respective README.md file.

*NodeJS: [https://github.com/EnableX/Video-Conferencing-Open-Source-Web-Application-Sample.git]
*PHP: [https://github.com/EnableX/Group-Video-Call-Conferencing-Sample-Application-in-PHP]

Note the following:

* You need to use App ID and App Key to run this Service.
* Your iOS Client EndPoint needs to connect to this Service to create Virtual Room and Create Token to join the session.
* Application Server is created using EnableX Server API while Rest API Service helps in provisioning, session access and post-session reporting.  

To know more about Server API, go to:
https://developer.enablex.io/docs/references/apis/video-api/index/


## 3. iOS Toolkit

This Sample Applcation uses EnableX iOS Toolkit to communicate with EnableX Servers to initiate and manage Real-Time Communications. Please update your Application with latest version of EnableX IOS Toolkit as and when a new release is available.   

* Documentation: https://developer.enablex.io/docs/references/sdks/video-sdk/ios-sdk/index/
* Download Toolkit: https://developer.enablex.io/docs/references/sdks/video-sdk/ios-sdk/index/


## 4. Application Walk-through

### 4.1 Create Token

We create a Token for a Room Id to get connected to EnableX platform to connect to the Virtual Room to carry out an RTC Session.

To create Token, we make use of Server API. Refer following documentation:
https://developer.enablex.io/docs/references/apis/video-api/content/api-routes/#create-a-room


### 4.2 Connect to a Room

We use the Token to get connected to the Virtual Room. Once connected with room, user in same room can exchange their message to each other.
https://developer.enablex.io/docs/references/sdks/video-sdk/ios-sdk/room-connection/index/

### 4.3 Send Data
``` 
/* Send Data*/
EnxRoom.sendMessage(text, broadCast: true, clientIds: [])
/* Here user will send chat message to all participents or listed participent's in room

    broadCast = true/false
        To send to all Participants in the room set broadCast = true. Otherwise set it to false to send to a list of Recipients.    
    clientIds = [] 
        Pass a list of recipient clientId. To send to all participants, pass [] or nil as clientId.
*/

/* Example of Delegates */
/* Delegate: didConnect 
Handles successful connection to the Virtual Room */ 

func room(_ room: EnxRoom?, didConnect roomMetadata: [AnyHashable : Any]?) { 
    /* You may initiate and publish your stream here */
} 


/* Delegate: didError
 Error handler when room connection fails */
 
func room(_ room: EnxRoom?, didError reason: String?) { 

} 
/* Delegate: userDidJoined
 To handle any new user added to the Virtual Room */
 
func room(_ room: EnxRoom?, userDidJoined Data: [Any]?) {
  //Handle new user connected in the room
} 

/* Delegate: userDidDisconnected
 To handle any user left from Virtual Room */
  
func room(_ room: EnxRoom?, userDidDisconnected Data: [Any]?) {
    //Handle new user disconnected from the room
}
/* Delegate: didReceiveChatDataAtRoom
To handle any chat recieve at room */
 func room(_ room: EnxRoom, didReceiveChatDataAtRoom data: [Any]?) {
    /* Handle chat UI here */
}
```


## 5 Trial

EnableX provides hosted Demo Application Server of different use-case for you to try out.

1. Try a quick Video Call: https://try.enablex.io
2. Sign up for a free trial https://portal.enablex.io/cpaas/trial-sign-up/

