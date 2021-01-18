const functions = require('firebase-functions');
const admin =  require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
console.log("Follower Created", snapshot.id)
exports.onCreateFollower = functions.firestore
.doc("/followers/{userID}/userFollowers/{followerID}")
.onCreate( async (snapshot,context)=>{
const userId = context.params.userID
const followerId = context.params.followerID

// 1) Get followed users ref
 const followedUserPostsRef = admin
 .firestore()
 .collection('posts')
 .doc(userId)
 .collection('userPosts');

 // 2) Get following user's timeline ref
 const timelinePostsRef - admin
 .firestore()
 .collection('timeline')
 .doc(followerID)
 .collection('timelinePosts')

// 3)   Get followed users posts
const querySnapshot = await followedUserPostsRef.get();

 // 4) Add each user post to following user's timeline
 querySnapshot.forEach(doc => {
 if(doc.exists){
    const postID = doc.id;
    const postData  = doc.data();
    timelinePostsRef.doc(postID).set(postData);
 }
 })
  })

 exports.onDeleteFollower = functions.firestore
 .doc("/followers/{userID}/userFollowers/{followerID}")
 .onDelete(async (snapshot,context)=> {
    console.log("Follower Deleted", snapshot.id);

    const userID = context.params.userID;
    const followerID = context.params.followerID;

    const timelinePostsRef - admin
     .firestore()
     .collection('timeline')
     .doc(followerID)
     .collection('timelinePosts').where('ownerID', '==',userID);

     const querySnapshot = await timelinePostsRef.get();
     querySnapshot.forEach(doc => {
     if(doc.exists){
     doc.ref.delete();
     }
     }
     )
      })

     // when a post is created, add post to timeline of each follower(of the post owner)
 exports.onCreatePost = functions.firestore
            .doc('/posts/{userID}/userPosts/{postID}')
            .onCreate( async (snapshot, context)=>{
            const postCreated = snapshot.data();

            const userID = context.params.userID;
            const postID = context.params.postID;

            //1) Get all the followers of the user who made the post
            const userFollowersRef = admin.firestore()
            .collection('followers')
            .doc(userID)
            .collection("userFollowers");

            const querySnapshot = await userFollowersRef.get();
            //2) Add new post to each of the followers' timeline
            querySnapshot.forEach(doc => {
            const followerID = doc.id;

            admin
            .firestore()
            .collection('timeline')
            .doc(followerID)
            .collection("timelinePosts")
            .doc(postID)
            .set(postCreated);
            });
            })

 exports.onCreatePost = functions.firestore
      .doc('/posts/{userID}/userPosts/{postID}')
      .onCreate( async (snapshot, context)=>{
      const postCreated = snapshot.data();

      const userID = context.params.userID;
      const postID = context.params.postID;

      //1) Get all the followers of the user who made the post
      const userFollowersRef = admin.firestore()
      .collection('followers')
      .doc(userID)
      .collection("userFollowers");

      const querySnapshot = await userFollowersRef.get();
      //2) Add new post to each of the followers' timeline
      querySnapshot.forEach(doc => {
      const followerID = doc.id;

      admin
      .firestore()
      .collection('timeline')
      .doc(followerID)
      .collection("timelinePosts")
      .doc(postID)
      .set(postCreated);
      });
      })

 exports.onDeletePost = functions.firestore
      .doc('/posts/{userID}/userPosts/{postID}')
      .onCreate( async (snapshot, context)=>{
      const postCreated = snapshot.data();

      const userID = context.params.userID;
      const postID = context.params.postID;

      //1) Get all the followers of the user who made the post
      const userFollowersRef = admin.firestore()
      .collection('followers')
      .doc(userID)
      .collection("userFollowers");

      const querySnapshot = await userFollowersRef.get();
      //2) delete post to each of the followers' timeline
      querySnapshot.forEach(doc => {
      const followerID = doc.id;

      admin
      .firestore()
      .collection('timeline')
      .doc(followerID)
      .collection("timelinePosts")
      .doc(postID)
      .get().then(doc=> {
      if(doc.exists){
      doc.ref.delete();
      }
      })
      });
      })






