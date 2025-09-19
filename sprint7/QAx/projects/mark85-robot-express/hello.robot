*** SETTINGS ***
Documentation     Um exemplo em Robot Framework

Library           mylib.py

*** Test Cases ***
Deve mostrar mensagem de boas vindas
    Log To Console    Hello Robot Framework

    my_log    Hello Robot Framework from mylib.py