# CdmInspection
OMOP-CDM 품질 관리 및 검사 지원 R 패키지

# 개요

검사 보고서의 목표는 수행 된 추출 변환 및로드 (ETL) 프로세스의 완전성, 투명성 및 품질에 대한 통찰력을 제공하고 EHDEN 및 OHDSI 데이터 네트워크에 온 보딩하고 연구에 참여할 데이터 파트너의 준비 상태를 제공하는 것입니다. 


# 특징

**추출/변환/적재**  
1. 데이터 테이블 내 레코드수 
2. 환자 당 고유 개념 수 
3. Achilles Heel 결과
4. 데이터 밀도 그림

**용어 매핑**
1. OMOP 용어 버전
2. 테이블별 레코드 수
3. 용어 매핑의 완전성
4. 약물 매핑

**기술 인프라**
1. OHDSI HADES 패키지 설치 여부
2. 시스템 정보

**연구 활용 가능성**
1. 샘플 코호트 생성

**결과 보고서 생성**

모든 결과를 포함하는 FEEDER-NET 템플릿 워드 문서를 생성합니다. 이 템플릿은 cdm 검사를 수행하는 사람이 작성해야합니다. 

Technology
==========
The CdmInspection package is an R package.

System Requirements
===================
Requires R. Some of the packages used by CdmInspection require Java.

Installation
=============

1. See the instructions [here](https://ohdsi.github.io/Hades/rSetup.html) for configuring your R environment, including Java.

2. Make sure RohdsiWebApi is installed

```r
  remotes::install_github("OHDSI/ROhdsiWebApi")
```

3. In R, use the following commands to download and install CdmInspection:

```r
  remotes::install_github("ABMI/CdmInspection", ref = "translate-kor")
```

User Documentation
==================

You should run the cdmInspection package ideally on the same machine you will perform actual anlyses so we can test its performance.

Make sure that Achilles has run in the results schema you select when calling the cdmInspection function.

PDF versions of the documentation are available:
* Package manual: [Link](https://github.com/EHDEN/CdmInspection/blob/master/extras/CdmInspection.pdf)
* CodeToRun Example: [Link](https://github.com/EHDEN/CdmInspection/blob/master/extras/CodeToRun.R)
* Report Example: [Link](https://github.com/EHDEN/CdmInspection/blob/master/extras/SYNPUF-results.docx)

Support
=======
* We use the <a href="https://github.com/EHDEN/CdmInspection/issues">GitHub issue tracker</a> for all bugs/issues/enhancements/questions/feedback

Contributing
============
This package is maintained by the EHDEN consortium as part of its quality control procedures. Additions are welcome through pull requests. We suggest to first create an issue and discuss with the maintainer before implementing additional functionality.

The roadmap of this tool can be found [here](https://github.com/EHDEN/CdmInspection/projects/1)

License
=======
CdmInspection is licensed under Apache License 2.0

Development
===========
CdmInspection is being developed in R Studio.

### Development status

Stable Release

