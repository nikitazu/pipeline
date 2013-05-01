Feature: Line
    Testing combinations of pipes on line
    
    Scenario: Download file, zip it and send via email
        When I run `piper line http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download readme.txt nikitazu@gmail.com`
        Then the output should contain "HTTP: writing file /tmp/hclerk/readme.txt\nHTTP: ok\n"
        And the output should contain "7Z: volumes created"
        And the output should contain "E-Mail: sending file /tmp/hclerk/readme.txt.7z.d/readme.txt.7z.001 of 1\nE-Mail: ok\n"
        And the file "/tmp/hclerk/readme.txt" should exist
        And the directory "/tmp/hclerk/readme.txt.7z.d" should exist
        And the file "/tmp/hclerk/readme.txt.7z.d/readme.txt.7z.001" should exist
