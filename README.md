# iOS

1. Module for taking photoes </br></br>
This is a module that can be integrated in the app to take control of the camera, take photoes and save the uri for later usage.</br></br>
How to use it: it can be brought up from another viewController, like so.
let photoController = ImagePickerController()</br> 
photoController.sourceType = .photoLibrary </br>
photoController.imagePickerDelegate = self</br>
present(photoController, animated: true, completion: nil)</br>
This viewController inherits an ImagePickerControllerDelegate where it is required to implement the onUserClickUseButton and onUserClickCancelButton functions. These two functions will be called from inside the ImagePickerController to pass the filename back to the calling viewController. Then the calling viewController can manipulate the data passed back from ImagePickerController, for example, in my app, the filename is appened to an attachments array which is later on used to upload the image up to the server.
