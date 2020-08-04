# thejointapp

Strictly follow the rules provided below for coding:

1. Name all the files and folders using snake case (sign_in)
2. Name all the variables and methods in the code using camel case (String fullName, void newMethod)
3. Stick to the app structure given below to create any new file/folder.
4. Whenever possible use methods.
5. Define variables at the top of state class (Widget build(BuildContext context)) and methods below the class (but within the class itself).
6. Every method should have a comment describing the use of methods. Comments are to be made just above the method without leaving a line in between the comment and method.
7. There should be two line gaps between two methods.
8. Names of all the collections and subcollections at the backend will be named using camel case (userDetails, socialFeedPage)


APP STRUCTURE:

lib :
1. commom_screens -> this will contain screens which are not a part of any module/feature of the app and are common to all. Eg. sign_in, update_profile, loading etc.

2. module wise folders -> all the module wise folders will be directly in the lib folder. eg. social, academics, god, dating etc.
    2.1. The screens under a particular module should be named as:  moduleName_screenName (eg. social_home, academics_home)
    
3.  authenticate-> This folder has one file which swtiches between sign_in or sign_up screens

4. services-> This folder should contain files responsible for providing backend services(authenticate service or database service) all the backend service methods should be here.

5. models-> This folder has model files for user, post, study_material, etc

6. wrapper.dart-> Please do not touch this file. This is a file responsible for listeninng to user auth changes.

7. main.dart-> Please do no touch this file.
    
    * if you have any question regarding the placement of any file/folder ask on our slack channel. I have created some blank files already, you may first check if your required file is created or not. If not, then only create a new one.
    
    
    BACKEND STRUCTURE:
        
        main collections are as follows:
        1. userDetails -> this will have documents with the details of all the user from our app with the docId as a unique identification number (uid)
        
        2. social -> this collection will have all the data realated to the social module of the app. Some of its subcollections are:
            2.1. socialFeedPage -> this subcollection will have documents of all the posts created by all the uses to be shown on the feed 
            2.2 socialPostRecations -> this subcollections will have a documents of the user reactions (like, comment, report, reshare) by the names of the type of reaction
                2.2.1 Each document will have a subcollection with documents named using postId(which will be unique to each post)
            2.3 hashtag -> collection will be here(subcollection of 'socaial' collection)
            2.4 socialUserPosts -> this is again a subcollection of social which will have a subcollection with the name as uid of each user, all the documents in this will contain all the posts made by a particular user.
            
        3. Academics is a new collection directly
        
    
    HAPPY CODING...
    
    
