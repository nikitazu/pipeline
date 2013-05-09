Feature: Pipe
    Testing different pipes here

    Scenario: Follow uri from tenshi.ru
        When I run `piper uri http://tenshi.ru/anime-ost/Air/Air.Movie.OST/09%20-%20Dai%20san%20Shinpi%20Kou.mp3`
        Then the output should contain "URI: content length=2050228\n"
        And the output should contain "URI: filename=09_Dai_san_Shinpi_Kou.mp3\n"
        
    Scenario: Follow uri from sourceforge.net
        When I run `piper uri http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download`
        Then the output should contain "URI: content length=2263\n"
        And the output should contain "URI: filename=readme.txt"

    Scenario: Follow uri from tenshi.ru no safe filename
        When I run `piper uri http://tenshi.ru/anime-ost/Air/Air.Movie.OST/09%20-%20Dai%20san%20Shinpi%20Kou.mp3 --filename=tenshi.mp3`
        Then the output should contain "URI: filename=tenshi.mp3\n"

    Scenario: Follow uri from tenshi.ru renaming
        When I run `piper uri http://tenshi.ru/anime-ost/Air/Air.Movie.OST/09%20-%20Dai%20san%20Shinpi%20Kou.mp3 -s=no`
        Then the output should contain "URI: filename=09 - Dai san Shinpi Kou.mp3\n"
            
    Scenario: Download file from tenshi.ru
        When I run `piper http http://tenshi.ru/anime-ost/Air/Air.Movie.OST/09%20-%20Dai%20san%20Shinpi%20Kou.mp3 tenshi.mp3`
        Then the output should contain "HTTP: writing file /tmp/hclerk/tenshi.mp3\nHTTP: ok\n"
        And the file "/tmp/hclerk/tenshi.mp3" should exist
    
    Scenario: Download file from sourceforge.net
        When I run `piper http http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download readme.txt`
        Then the output should contain "HTTP: writing file /tmp/hclerk/readme.txt\nHTTP: ok\n"
        And the file "/tmp/hclerk/readme.txt" should exist
    
    Scenario: Create 7z archive
        When I run `piper zip7 '/tmp/hclerk/tenshi.mp3' -p1`
        Then the output should contain "7Z: volumes created"
        And the directory "/tmp/hclerk/tenshi.mp3.7z.d" should exist
        And the file "/tmp/hclerk/tenshi.mp3.7z.d/tenshi.mp3.7z.001" should exist
        And the file "/tmp/hclerk/tenshi.mp3.7z.d/tenshi.mp3.7z.002" should exist
        
    Scenario: Send parts via e-mail
        When I run `piper email /tmp/hclerk/readme.txt nikitazu@gmail.com`
        Then the output should contain "E-Mail: sending file /tmp/hclerk/readme.txt of 1\nE-Mail: ok\n"
    

