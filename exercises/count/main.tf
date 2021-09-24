
resource "local_file" "test_file" {
  count = 4
  filename = "./test-${count.index}.txt"
  content  = "This is Infrastructure as Code with Terrfaform Workshop! - ${count.index}"
}