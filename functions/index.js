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
.doc("/followers/{userID}/userFollowers/{followerId})
.onCreate((snapshot,context)=>{
const userId = context.params.userId
const followerId = context.params.followerId

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
 .doc(followerId)
 .collection('timelinePosts')
 }) )

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


