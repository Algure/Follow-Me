# follow_me

A simple Flutter application powered by Azure to enable you follow me on twitter 🌝

Check out the live web app here: [https://algure.github.io/followme2](https://algure.github.io/followme2/#/)

This app saves details of user's social media accounts on an azure cognitive search index.
The app enables you find users based on key words in their biographies. You can also filter through users based on their age range.

## Usage.

### Sign Up.
Sign up with a link to your social media (twitter) account (some other accounts are accepted 🤐). You'll need to input an actual https link. Enter a unique password (Something simple you can remember). Then click on sign-up.

### Log In.

You'll need the same details you used to sign up and this time, you click on login.
Authentication is handled via Azure serverless functions.

### Profile.

When you sign up, you would have to edit your profile by clicking on the floating action button. Fill in all your details especially your bio so I can find you 😅. Then click on the update button. Wait a bit and you're all set.

### Search

On the home screen, click on the search icon to reveal a text editor. The key word you input would be used to search through user names and biographies for the best matches.

### Filter

Click on the filter icon to filter through users based on their age range. A dropdown lets you select the filter parameters.

Have fun and remember to Follow Me 😉.

Check out the following links to learn more about Azure [cognitve search](https://azure.microsoft.com/en-us/services/search/) and [serverless functions](https://azure.microsoft.com/en-us/services/functions/).

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
