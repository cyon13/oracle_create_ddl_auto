# oracle_create_ddl_auto
Script that automatically generates oracle database create ddl statements using mapping file 

##1. CSV 파일 준비
![image](https://user-images.githubusercontent.com/35316595/175196147-325f9498-1765-4484-ae39-3077d1b7bd31.png)

![image](https://user-images.githubusercontent.com/35316595/175202206-017ea822-6a8b-4a10-b4f5-8e2ec7d2c4a3.png)


##2. 실행
```bash
bash create_ddl.sh <csv file>
# bash create_ddl.sh sample.csv
```

##3. 옵션 설정
- SCHEMA : 스키마 정보 입력 (default : none)
- HEADER Y/N : 헤더 여부 입력 (default : Y)
- SEPERATOR : 구분자 설정 (default : |)
- OPTION : 테이블 CREATE 옵션 설정 (default : NOLOGGING COMPRESS BASIC)
- OUTPUT FILENAME : 출력 파일 설정 (default : RESULT_DDL.sql)
![image](https://user-images.githubusercontent.com/35316595/175203775-f7d9a170-0ed3-4685-b586-ed71d78d8dfb.png)

##4. 결과 확인

```bash
cat RESULT_DDL.sql
```
![image](https://user-images.githubusercontent.com/35316595/175203724-6cf7b4c7-dc08-42e8-9d52-742c2fe418e3.png)
