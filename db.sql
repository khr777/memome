DROP DATABASE IF EXISTS `memome`;
CREATE DATABASE `memome`;
USE `memome`;

# member 테이블 생성
CREATE TABLE `member` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    delDate DATETIME,
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    authStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    loginId CHAR(20) NOT NULL UNIQUE,
    loginPw CHAR(100) NOT NULL,
    `name` CHAR(20) NOT NULL,
    `nickname` CHAR(20) NOT NULL UNIQUE,
    `email` CHAR(100) NOT NULL UNIQUE,
    `cellphoneNo` CHAR(20) NOT NULL 
);

SELECT *
FROM `member`;

# 게시판 테이블 생성
CREATE TABLE `board`(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    delDate DATETIME,
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `code` CHAR(20) NOT NULL UNIQUE,
    `name` CHAR(20) NOT NULL UNIQUE
    
);



# 게시물 테이블 생성
CREATE TABLE article (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    delDate DATETIME,
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    title CHAR(200) NOT NULL,
    `body` LONGTEXT NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    boardId INT(10) UNSIGNED NOT NULL
);

# memo 카테고리  테이블 생성
DROP TABLE IF EXISTS memo;
CREATE TABLE memo (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    delDate DATETIME,
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `name` CHAR(200) NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    boardId INT(10) UNSIGNED NOT NULL
);

INSERT INTO `board`
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'free',
`name` = '자유';

INSERT INTO `board`
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'notice',
`name` = '공지사항';


INSERT INTO `board`
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'memome',
`name` = '나의메모';


INSERT INTO `board`
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'memoyou',
`name` = '모두의메모';

INSERT INTO `board`
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'memberPage',
`name` = '회원메모';


SELECT *
FROM `member`;

# SELECT * 
# FROM article
# ORDER BY id DESC


# 부가정보테이블(임시 비밀번호 발송 여부, 개인정보 변경 외)
CREATE TABLE attr (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `relTypeCode` CHAR(20) NOT NULL,
    `relId` INT(10) UNSIGNED NOT NULL,
    `typeCode` CHAR(30) NOT NULL,
    `type2Code` CHAR(30) NOT NULL,
    `value` TEXT NOT NULL,
    `expireDate` DATETIME NULL
);

# attr 유니크 인덱스 걸기
## 중복변수 생성금지
## 변수찾는 속도 최적화
ALTER TABLE `attr` ADD UNIQUE INDEX (`relTypeCode`, `relId`, `typeCode`, `type2Code`); 

## 특정 조건을 만족하는 회원 또는 게시물(기타 데이터)를 빠르게 찾기 위해서
ALTER TABLE `attr` ADD INDEX (`relTypeCode`, `typeCode`, `type2Code`);


DROP TABLE IF EXISTS `file`;
/* 파일 테이블 생성 */
CREATE TABLE `file` (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	relTypeCode CHAR(50) NOT NULL,
	relId INT(10) UNSIGNED NOT NULL,
    originFileName VARCHAR(100) NOT NULL,
    fileExt CHAR(10) NOT NULL,
    typeCode CHAR(20) NOT NULL,
    type2Code CHAR(20) NOT NULL,
    fileSize INT(10) UNSIGNED NOT NULL,
    fileExtTypeCode CHAR(10) NOT NULL,
    fileExtType2Code CHAR(10) NOT NULL,
    fileNo TINYINT(2) UNSIGNED NOT NULL,
    `body` LONGBLOB
);

# 파일 테이블에 유니크 인덱스 추가
ALTER TABLE `file` ADD UNIQUE INDEX (`relId`, `relTypeCode`, `typeCode`, `type2Code`, `fileNo`); 

# 파일 테이블의 기존 인덱스에 유니크가 걸려 있어서 relId가 0 인 동안 충돌이 발생할 수 있다. 그래서 일반 인덱스로 바꾼다.
ALTER TABLE `file` DROP INDEX `relId`, ADD INDEX (`relId` , `relTypeCode` , `typeCode` , `type2Code` , `fileNo`); 

DROP TABLE IF EXISTS hashtag ;
CREATE TABLE hashtag (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    delDate DATETIME,
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `relTypeCode` CHAR(20) NOT NULL,
    `relId` INT(10) UNSIGNED NOT NULL,
    tag CHAR(200) NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL
 #   tagNo int(10) unsigned not null
);

UPDATE `board`
SET updateDate = NOW(),
`code` = 'memoME'
WHERE id =3;



UPDATE `board`
SET updateDate = NOW(),
`code` = 'memoYOU'
WHERE id =4;




SELECT *
FROM `attr`;

SELECT *
FROM `member`;

SELECT *
FROM board;

SELECT *
FROM memo;

SELECT *
FROM memo;

SELECT *
FROM article
WHERE id= 24;

UPDATE article
SET delDate = NOW(),
delStatus = 1
WHERE memberId = 1
AND id = 15

SELECT *
FROM hashtag
WHERE relId = 24
AND memberId = 1;

SELECT *
FROM `file`
WHERE relId = 24;

DELETE FROM hashtag
WHERE relId = 23
AND  memberId = 1


SELECT *
FROM memo
WHERE id= 17;


UPDATE FILE A
JOIN FILE B
ON A.fileNo = B.fileNo
SET A.body = B.body
WHERE A.id = 75
AND B.id = 71

SELECT *
FROM `file`;

DESC `file`;

SELECT *
FROM `file`
WHERE relId = 16;

DELETE FROM FILE
WHERE relId = 16;

SELECT *
FROM attr;

SELECT *
FROM `board`;

SELECT *
FROM hashtag
WHERE relId = 16;



DELETE FROM hashtag
WHERE relId = 90
AND tag = '수정'
AND  memberId = 1
AND  tagNo= 3

SELECT *
FROM hashtag
WHERE relId = 10;

    SELECT A.*,	
    GROUP_CONCAT(HT2.tag) AS extra__hashTagsStr
    FROM  article AS A
    INNER JOIN hashtag AS HT2
    ON A.id = HT2.relId
    INNER JOIN hashtag AS HT
    ON A.id = HT.relId
    WHERE HT.tag = '웁스'
    AND HT.relTypeCode = 'article'
    AND A.displayStatus = 1
    AND A.memberId = 1
    AND A.delStatus = 0
    GROUP BY A.id
    ORDER BY A.id DESC
    
    SELECT *
    FROM article;

SELECT *
FROM board;





DESC board;





CREATE TABLE reply (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME,
    updateDate DATETIME,
    memberId INT(10) UNSIGNED NOT NULL,
    delDate DATETIME,
	delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	displayStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    `body` LONGTEXT NOT NULL,
    relId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL
);



INSERT INTO `board`
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'unicon',
`name` = '유니콘';