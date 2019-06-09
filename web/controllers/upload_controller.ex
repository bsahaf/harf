defmodule Discuss.UploadController do
    use Discuss.Web, :controller
    alias Discuss.Upload
    alias Discuss.Router.Helpers

    def new(conn, _params) do
     changeset = Upload.changeset(%Upload{})
     render conn, "upload.html", changeset: changeset
    end


   def create(conn, %{"upload" => %{"image" => image_params} = upload_params}) do
     file_uuid = UUID.uuid4(:hex)        
     image_filename = image_params.filename
     unique_filename = "#{file_uuid}-#{image_filename}"
     {:ok, image_binary} = File.read(image_params.path)           
     
     bucket_name = "basim-image-storage-bucket"

     bucket_name 
     |> ExAws.S3.put_object(unique_filename, image_binary)
     |> ExAws.request!
    
     # build the image url and add to the params to be stored
     image_params = %{
        image_url: "https://#{bucket_name}.s3.amazonaws.com/#{bucket_name}/#{unique_filename}"
     }
     
     changeset = Upload.changeset(%Upload{}, image_params)
     
     case Repo.insert(changeset) do
       {:ok, _upload} ->
           conn
           |> put_flash(:info, "Image uploaded successfully!")
           |> redirect(to: upload_path(conn, :new))
       {:error, changeset} ->
           render conn, "upload.html", changeset: changeset
     end
    end
end