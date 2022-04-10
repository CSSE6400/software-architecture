resource "local_file" "url" {
  content = "https://csse6400.uqcloud.net"
  filename = "./api.txt"
}