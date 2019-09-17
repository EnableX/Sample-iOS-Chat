#  A Sample Chat App with EnableX iOS Toolkit

This is a sample Chat App demonstrates the use of  EnableX (https://www.enablex.io) platform Server APIs and iOS Toolkit to build iOS chat application. It allows developers to ramp up on app development by hosting on their own devices. 

This App creates a virtual Room on the fly  hosted on the Enablex platform using REST calls and uses the Room credentials (i.e. Room Id) to connect to the virtual Room as a mobile client.  The same Room credentials can be shared with others to join the same virtual Room to carry out a RTC (Real Time Communication) session. 

> EnableX Developer Center: https://developer.enablex.io/


## 1. How to get started

### 1.1 Pre-Requisites

#### 1.1.1 App Id and App Key 

* Register with EnableX [https://www.enablex.io] 
* Create your Application
* Get your App ID and App Key delivered to your Email


#### 1.1.2 Sample iOS Client 

* Clone or download this Repository [https://github.com/EnableX/Sample-iOS-Chat.git] 


#### 1.1.3 Sample App Server 

* Clone or download this Repository [https://github.com/EnableX/One-to-One-Video-Chat-Sample-Web-Application.git] & follow the steps further 
* You need to use App ID and App Key to run this Service. 
* Your iOS Client End Point needs to connect to this Service to create Virtual Room.
* Follow README file of this Repository to setup the Service.


#### 1.1.4 Configure iOS Client 

* Open the App
* Go to VCXConstant.swift and change the following:
``` 
 let userName = "USERNAME"  /* HTTP Basic Auth Username of App Server */
 let password = "PASSWORD"  /* HTTP Basic Auth Password of App Server */
 let kBaseURL = "FQDN"      /* FQDN of of App Server */
 ```
 
 Note: The distributable comes with demo username and password for the Service. 

### 1.2 Test

#### 1.2.1 Open the App

* Open the App in your Device. You get a form to enter Credentials i.e. Name & Room Id.
* You need to create a Room by clicking the "Create Room" button.
* Once the Room Id is created, you can use it and share with others to connect to the Virtual Room to carry out a RTC Session.
  
## 2 Server API

EnableX Server API is a Rest API service meant to be called from Partners' Application Server to provision video enabled 
meeting rooms. API Access is given to each Application through the assigned App ID and App Key. So, the App ID and App Key 
are to be used as Username and Password respectively to pass as HTTP Basic Authentication header to access Server API.
 
For this application, the following Server API calls are used: 
* https://api.enablex.io/v1/rooms - To create new room
* https://api.enablex.io/v1/rooms/:roomId - To get information of a given Room
* https://api.enablex.io/v1/rooms/:roomId/tokens - To create Token for a given Room to get into a RTC Session

To know more about Server API, go to:
https://developer.enablex.io/api/server-api/


## 3 iOS Toolkit

iOS App to use iOS Toolkit to communicate with EnableX Servers to initiate and manage Real Time Communications.  

* Documentation: https://developer.enablex.io/api/client-api/ios-toolkit/
* Download: https://developer.enablex.io/downloads/ios-toolkit/


## 4 Application Walk-through

### 4.1 Create Token

We create a Token for a Room Id to get connected to EnableX platform to connect to the Virtual Room to carry out a RTC Session.

To create Token, we make use of Server API. Refer following documentation:
https://developer.enablex.io/api/server-api/api-routes/rooms-route/#create-token


### 4.2 Connect to a Room

We use the Token to get connected to the Virtual Room. Once connected with room, user in same room can exchange their message to each other.
https://developer.enablex.io/api/client-api/ios-toolkit/enxrtc/


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
