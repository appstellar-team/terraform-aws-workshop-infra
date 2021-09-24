resource "local_file" "test_file" {
  filename = "./test.txt"
  content  = "This is Infrastructure as Code with Terrfaform Workshop!"
}