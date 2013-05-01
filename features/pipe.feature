Feature: Pipe
    Testing different pipes here

    Scenario: Download file from tenshi.ru
        When I run `piper http http://tenshi.ru/anime-ost/Air/Air.Movie.OST/09%20-%20Dai%20san%20Shinpi%20Kou.mp3 air.mp3`
        Then the output should contain "HTTP: writing file /tmp/hclerk/air.mp3\nHTTP: ok\n"
    
    Scenario: Download file from sourceforge.net
        When I run `piper http http://sourceforge.net/projects/cloverefiboot/files/readme.txt/download readme.txt`
        Then the output should contain "HTTP: writing file /tmp/hclerk/readme.txt\nHTTP: ok\n"
    
    Scenario: Create 7z archive
        When I run `piper zip7 /tmp/hclerk/air.mp3 -p1`
        Then the output should contain "7Z: volumes created"
