protocol ImagePickerControllerDelegate {
    func onUseButtonClick(_ sender: AnyObject?, fileName: String, image: Data)
    func onCancelPhotoButtonClick(_ sender: AnyObject?)
}
