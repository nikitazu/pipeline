Feature: Pipe
    Testing different pipes here

    Scenario: Download file from tenshi.ru
        When I run `piper http http://tenshi.ru/anime-ost/Air/Air.Movie.OST/09%20-%20Dai%20san%20Shinpi%20Kou.mp3`
        Then the output should contain "HTTP: writing file /tmp/hclerk/09 - Dai san Shinpi Kou.mp3\nHTTP: ok\n"
        And the file "/tmp/hclerk/09 - Dai san Shinpi Kou.mp3" should exist

    Scenario: Download file from tenshi.ru - ensure safe filenames
        When I run `piper http http://tenshi.ru/anime-ost/Air/Air.Movie.OST/09%20-%20Dai%20san%20Shinpi%20Kou.mp3 -s y`
        Then the output should contain "HTTP: writing file /tmp/hclerk/09_Dai_san_Shinpi_Kou.mp3\nHTTP: ok\n"
        And the file "/tmp/hclerk/09_Dai_san_Shinpi_Kou.mp3" should exist
    
    Scenario: Download file from sourceforge.net
        When I run `piper http http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download`
        Then the output should contain "HTTP: writing file /tmp/hclerk/readme.txt\nHTTP: ok\n"
        And the file "/tmp/hclerk/readme.txt" should exist
    
    Scenario: Create 7z archive
        When I run `piper zip7 '/tmp/hclerk/09 - Dai san Shinpi Kou.mp3' -p1`
        Then the output should contain "7Z: volumes created"
        And the directory "/tmp/hclerk/09 - Dai san Shinpi Kou.mp3.7z.d" should exist
        And the file "/tmp/hclerk/09 - Dai san Shinpi Kou.mp3.7z.d/09 - Dai san Shinpi Kou.mp3.7z.001" should exist
        And the file "/tmp/hclerk/09 - Dai san Shinpi Kou.mp3.7z.d/09 - Dai san Shinpi Kou.mp3.7z.002" should exist
        
    Scenario: Send parts via e-mail
        When I run `piper email /tmp/hclerk/readme.txt nikitazu@gmail.com`
        Then the output should contain "E-Mail: sending file /tmp/hclerk/readme.txt of 1\nE-Mail: ok\n"
    

