
#' Generates the Results Document
#'
#' @description
#' \code{generateResultsDocument} creates a word document with results based on a template
#' @param results             Results object from \code{cdmInspection}
#'
#' @param outputFolder        Folder to store the results
#' @param docTemplate         Name of the document template (EHDEN)
#' @param authors             List of author names to be added in the document
#' @param databaseDescription Description of the database
#' @param databaseName        Name of the database
#' @param databaseId          Id of the database
#' @param smallCellCount      Date with less than this number of patients are removed
#' @param silent              Flag to not create output in the terminal (default = FALSE)
#' @export
generateResultsDocumentKor<- function(results, outputFolder, docTemplate="EHDEN", authors = "Author Names", databaseDescription, databaseName, databaseId,smallCellCount,silent=FALSE) {

  if (docTemplate=="EHDEN"){
    docTemplate <- system.file("templates", "Template-EHDEN.docx", package="CdmInspection")
    logo <- system.file("templates", "pics", "ehden-logo.png", package="CdmInspection")
  } else if(docTemplate == "FEEDERNET"){
    docTemplate <- system.file("templates", "Template-FEEDERNET.docx", package="CdmInspection")
    logo <- system.file("templates", "pics", "feedernet-logo.png", package="CdmInspection")
  } else {}

  ## open a new doc from the doctemplate
  doc<-officer::read_docx(path = docTemplate)
  ## add Title Page
  doc<- doc %>%
    officer::body_add_img(logo, width=6.10,height=1.59, style = "Title") %>%
    officer::body_add_par(value = paste0("공통데이터모델 품질 검사 보고서: ",databaseName), style = "Title") %>%
    #body_add_par(value = "Note", style = "heading 1") %>%
    officer::body_add_par(value = paste0("보고서 버전: ", packageVersion("CdmInspection")), style = "Centered") %>%
    officer::body_add_par(value = paste0("일시: ", Sys.time()), style = "Centered") %>%
    officer::body_add_par(value = paste0("작성자: ", authors), style = "Centered") %>%
    officer::body_add_break()

  ## add Table of content
  doc<-doc %>%
    officer::body_add_par(value = "목차", style = "heading 1") %>%
    officer::body_add_toc(level = 2) %>%
    officer::body_add_break()


  ## add genereal section

  items <- c("기관명",
             "데이터베이스 이름",
             "데이터베이스 약어 표기",
             "담당자",
             "E-mail",
             "변환 기관",
             "변환 기관 담당자",
             "변환 기관 E-mail"
  )
  answers <- c("",databaseName, databaseId,"","","","","")
  preample <- data.frame(items,answers)
  colnames(preample) <- c("항목", "내용")
  ft <- flextable::qflextable(preample)
  ft<-flextable::set_table_properties(ft, width = 2, layout = "fixed")
  ft <- flextable::bold(ft, bold = TRUE, part = "header")
  border_v = officer::fp_border(color="gray")
  border_h = officer::fp_border(color="gray")
  ft<-flextable::border_inner_v(ft, part="all", border = border_v )

  doc<-doc %>%
    officer::body_add_par(value = "개요", style = "heading 1") %>%

    officer::body_add_par(value = "본 공통데이터모델 검사 보고서의 목표는 수행된 추출 / 변환 / 적재(ETL) 과정의 완전성, 투명성 및 품질에 관한 통찰력을 제공하고 분산연구망 활용 연구에 참여하기 위한 각 기관의 데이터 준비 상태를 확인하기 위함입니다.") %>%

    officer::body_add_par(value = "담당자 및 연락처", style = "heading 2") %>%
    officer::body_add_par(value = "아래 표 빈칸을 채워주십시오",style="Highlight") %>%

    flextable::body_add_flextable(value = ft, align = "left")
  doc<-doc %>%
    officer::body_add_par(value = "데이터베이스 개요", style = "heading 2")

  if (is.null(databaseDescription)){
    doc<-doc %>%
      officer::body_add_par(value = paste0("> 데이터베이스에 대한 간단한 개요를 작성하십시오."), style="Highlight") %>%
      officer::body_add_break()
  } else {
    doc<-doc %>%
      officer::body_add_par(value = databaseDescription) %>%
      officer::body_add_break()
  }

  # doc <-  doc %>%
  #   body_add_par('체크 리스트', style = "heading 1") %>%
  #
  #   body_add_par("다음 검사를 수행하였습니까?", style = "Normal") %>%
  #   body_add_par("[  ] ATLAS 코호트 생성 (예시 - 제2형 당뇨병)", style = "Normal") %>%
  #   body_add_par("[  ] Achilles 결과 검토", style = "Normal") %>%
  #   body_add_par("비고:", style = "Normal")
  #
  # doc <-  doc %>%
  #   body_add_par("이 검사 보고서 외에 아래 언급된 모든 항목이 FEEDER-NET과 공유되는지 확인하여 주십시오.", style = "Normal") %>%
  #   body_add_par("[  ] ETL 문서", style = "Normal") %>%
  #   body_add_par("[  ] ETL 코드", style = "Normal") %>%
  #   body_add_par("[  ] DQ Dashboard json file", style = "Normal") %>%
  #   body_add_par("[  ] White Rabbit 결과", style = "Normal") %>%
  #   body_add_par("[  ] CdmInspection 결과 압축파일", style = "Normal") %>%
  #   body_add_par("비고:", style = "Normal")


  # doc<-doc %>% officer::body_add_par(value = "CDM 변환 업체의 역할", style = "heading 2") %>%
  #
  #   officer::body_add_par(value = "> CDM의 추출/변환/적재 (ETL) 단계에서 전문 변환업체가 역할을 수행했다면, 그 역할 및 범위에 대하여 기입하시오.",style="Highlight") %>%
  #   officer::body_add_break()


  ## ETL Development section

  doc<-doc %>%
    officer::body_add_par(value = "추출 / 변환 / 적재 (ETL)", style = "heading 1")
    # officer::body_add_par(paste0("이 섹션에서는 ETL 개발 및 실행 단계를 설명하고 품질 관리 단계에 대해 설명합니다.")) %>%
    # officer::body_add_par(value = "ETL 문서", style = "heading 2") %>%
    # officer::body_add_par("다음 ETL 사항을 검토하고 논의하십시오:", style="Highlight") %>%
    #
    # officer::body_add_par("> ETL 문서의 품질에 대하여 데이터 도메인 별로 완전성 및 세부 수준을 검토하십시오. 이상적으로는 Rabbit-in-a-Hat 매핑 정의 문서를 기반으로 합니다. 다른 중간 테이블을 활용하는 경우 이에 대하여 자세히 설명하여야 합니다.", style="Highlight") %>%
    # officer::body_add_par("> 적용된 변환/매핑 규칙에 대하여 자세한 내용이 포함되어 있고, 이는 THEMIS 규칙에 부합하는 것입니까?", style="Highlight") %>%
    # officer::body_add_par("> ETL 문서에 실제 ETL 코드가 정확하게 구현되어 있는지 확인하십시오. 이상적으로는 Rabbit-in-a-hat testFramework.R를 사용한 결과가 실행되고 공유됩니다. 이것이 가능하지 않은 경우, 적용되는 품질관리 메커니즘을 설명하여야 합니다.", style="Highlight") %>%
    # officer::body_add_par("> ETL 코드가 완전히 자동으로 실행됩니까? 아니면 수동 단계가 있습니까? 수동 단계가 있는 경우, 이에 대한 설명을 첨부해주십시오.", style="Highlight") %>%
    # officer::body_add_par(value = "ETL 구현", style = "heading 2") %>%
    # officer::body_add_par("ETL 구현에 사용되는 프로그래밍 기술 (언어) (SQL, R, Python 등)", style="Highlight") %>%
    #
    # officer::body_add_par("> 코드 해설과 구조에 관한 피드백을 제공하십시오. 최소 수준의 해설은 sql query에 대한 설명, R function에 대한 설명 등입니다. OHDSI에서 제공하는 지침을 참조하십시오. 코드 구조는 SQL/R 파일의 논리 구조를 나타냅니다. 파일은 대상 테이블로 이름을 지정하고 해당 도메인과 관련된 모든 코드를 포함하는 것이 좋습니다(예시 - insert_person.sql, insert_condition_occurrence.sql). 다른 방법이 적용되는 경우 세부 정보를 제공하십시오. ", style="Highlight") %>%
    #
    # officer::body_add_par("> 코드 버전 관리 메커니즘이 별도로 존재합니까?", style="Highlight") %>%
    # officer::body_add_break()


  ## add Concept counts
  if (!is.null(results$dataTablesResults)) {
    df_t1 <- results$dataTablesResults$dataTablesCounts$result
    colnames(df_t1) <- c("테이블명", "레코드 수", "환자 수 ", "Person 대비 환자 수 비율(%)", "Observation_period 대비 환자 수 비율(%)")

    doc<-doc %>%
      officer::body_add_par(value = "데이터 테이블 내 레코드 수", style = "heading 2") %>%
      officer::body_add_par("표 1. 모든 임상데이터 테이블의 레코드 수를 표시합니다.") %>%
      my_body_add_table(value = df_t1, style = "EHDEN") %>%
      officer::body_add_par(" ") %>%
      officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", results$dataTablesResults$dataTablesCounts$duration),"초 동안 수행되었습니다."))

    colnames(results$dataTablesResults$conceptsPerPerson$result) <- c("도메인", "최소", "10%", "25%", "중위 수", "75%", "90%", "최대")
    doc<-doc %>%
      officer::body_add_par(value = "환자 당 고유 개념 수", style = "heading 2") %>%
      officer::body_add_par("표 2. 모든 데이터 도메인에 대한 환자 개인 당 고유 개념의 수") %>%
      my_body_add_table(value = results$dataTablesResults$conceptsPerPerson$result, style = "EHDEN") %>%
      officer::body_add_par(" ")

    doc<-doc %>%
      officer::body_add_par(value = "Achilles Heel 결과", style = "heading 2") %>%
      officer::body_add_par("표 3. Achilles Heel 결과 내역")

    if (!is.null(results$performanceResults$achillesHeelResults$result)) {
      heelResult <- gsub(":.*", "", results$performanceResults$achillesHeelResults$result$ACHILLES_HEEL_WARNING) %>% table() %>% as.data.frame
      colnames(heelResult) <- c("유형", "계")

      doc<-doc %>%
        my_body_add_table(value =heelResult, style = "EHDEN") %>%
        officer::body_add_par("[부록 1] Achilles Heel 결과 상세 내역 참조")


    plot <- recordsCountPlot(as.data.frame(results$dataTablesResults$totalRecords$result))
    doc<-doc %>%
      officer::body_add_par(value = "데이터 밀도 그림", style = "heading 2") %>%
      officer::body_add_gg(plot, height=3) %>%
      officer::body_add_par("그림 1. 시간 경과에 따른 데이터 도메인 당 총 레코드 수")

    plot <- recordsCountPlot(as.data.frame(results$dataTablesResults$recordsPerPerson$result))
    doc<-doc %>%
      officer::body_add_gg(plot, height=3) %>%
      officer::body_add_par("그림 2. 시간 경과에 따른 데이터 도메인 당 환자 개인 당 레코드 수") %>%
      body_add_break()


    }else{
        doc<-doc %>%
          officer::body_add_par("쿼리가 결과를 반환하지 않았습니다. ", style="Highlight")
      }

  }


  ## Vocabulary checks section
  doc<-doc %>%
    officer::body_add_par(value = "용어 매핑", style = "heading 1")
  # %>%
  #   officer::body_add_par(value = "용어 매핑 프로세스가 구현된 방법과 품질관리 메커니즘이 무엇인지 설명하십시오.", style = "Highlight") %>%
  #   officer::body_add_par(value = "> 무작위 검사를 수행하기 위하여, 임의 매핑의 경우 Excel 파일 또는 source_to_concept_map 파일을 보고서와 함께 공유하여야 합니다. 이상적으로 이러한 목록은 원본 코드의 빈도에 따라 내림차순으로 정렬하여 주십시오.", style = "Highlight")

  vocabResults <-results$vocabularyResults
  if (!is.null(vocabResults)) {
    #vocabularies table

    doc<-doc %>%
      officer::body_add_par(value = "OMOP 용어", style = "heading 2") %>%
      officer::body_add_par(paste0("OMOP 용어 버전: ",results$vocabularyResults$version)) %>%
      officer::body_add_par(paste0("[부록2. OMOP 용어 개념 개수] 참조"))
    # %>%
    #   officer::body_add_par("표 3. 해당 CDM 내 가용한 OMOP 용어 개념의 개수. 단, 이는 실제 CDM 테이블 내에서 실제로 사용되는 개념을 반영하지는 않습니다. S = 표준 개념, C = 분류 개념, '-' = 비표준 개념") %>%
    #   my_body_add_table(value = vocabResults$conceptCounts$result, style = "EHDEN") %>%
    #   officer::body_add_par(" ") %>%
    #   officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", vocabResults$conceptCounts$duration),"초 동안 수행되었습니다."))
    ##%>% body_end_section_landscape()

    ## add vocabulary table counts

    colnames(vocabResults$vocabularyCounts$result) <- c("테이블 명", "개수")

    doc<-doc %>%
      officer::body_add_par(value = "테이블 레코드 수", style = "heading 2") %>%
      officer::body_add_par("표 4. 전체 용어 테이블의 레코드 수") %>%
      my_body_add_table(value = vocabResults$vocabularyCounts$result, style = "EHDEN") %>%
      officer::body_add_par(" ") %>%
      officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", vocabResults$vocabularyCounts$duration),"초 동안 수행되었습니다."))

    ## add Mapping Completeness
    vocabResults$mappingCompleteness$result$'%Codes Mapped' <- prettyHr(vocabResults$mappingCompleteness$result$'%Codes Mapped')
    vocabResults$mappingCompleteness$result$'%Records Mapped' <- prettyHr(vocabResults$mappingCompleteness$result$'%Records Mapped')

    colnames(vocabResults$mappingCompleteness$result) <- c("도메인", "원본 코드 수", "매핑된 코드 수", "매핑 코드 비율(%)", "원본 레코드수", "매핑된 레코드 수", "매핑 레코드 비율(%)")

    doc<-doc %>%
      officer::body_add_par(value = "용어 매핑의 완전성", style = "heading 2") %>%
      officer::body_add_par("표 5. 표준화된 어휘에 매핑된 코드의 비율과 레코드의 비율") %>%
      my_body_add_table(value = vocabResults$mappingCompleteness$result, style = "EHDEN", alignment = c('l', rep('r',6))) %>%
      officer::body_add_par(" ") %>%
      officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", vocabResults$mappingCompleteness$duration),"초 동안 수행되었습니다."))

    colnames(vocabResults$mappingStandard$result) <- c("도메인", "표준 개념 수", "분류 개념 수", "비표준 개념 수")
    doc<-doc %>%
      officer::body_add_par("표 6. 매핑된 코드의 표준/분류/비표준 개념 비율") %>%
      my_body_add_table(value = vocabResults$mappingStandard$result, style = "EHDEN", alignment = c('l', rep('r',3))) %>%
      officer::body_add_par(" ") %>%
      officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", vocabResults$mappingStandard$duration),"초 동안 수행되었습니다."))

    ## add Drug Level Mappings
    colnames(vocabResults$drugMapping$result) <- c("약물 개념 계열", "레코드 수", "환자 수", "원본 코드 수")
    doc<-doc %>%
      officer::body_add_par(value = "약물 매핑", style = "heading 2") %>%
      officer::body_add_par("표 7. 약물 매핑 수준") %>%
      my_body_add_table(value = vocabResults$drugMapping$result, style = "EHDEN") %>%
      officer::body_add_par(" ") %>%
      officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", vocabResults$drugMapping$duration),"초 동안 수행되었습니다.")) %>%
      officer::body_add_par(paste("약물 개념 계열 해설은 URL 참고: https://github.com/OHDSI/Vocabulary-v5.0/wiki/Vocab.-RXNORM_EXTENSION"))

    ## add source_to_concept_map breakdown

    colnames(vocabResults$sourceConceptFrequency$result) <- c("원본 용어체계 ID", "목표 용어체계 ID", "개수")

    # doc<-doc %>%
    #   officer::body_add_par(value = "원본코드-개념 매핑", style = "heading 2") %>%
    #   officer::body_add_par("> ETL에서 원본코드-개념 매핑 source-to-concept map 테이블을 사용하지 않은 경우 아래 테이블은 비어 있습니다. 이 경우 Excel 파일 등의 형식으로 임의 매핑에 대한 별도의 파일을 제출하십시오.", style="Highlight") %>%
    #   officer::body_add_par("표 19. 원본코드-개념 매핑 분석") %>%
    #   my_body_add_table(value = vocabResults$sourceConceptFrequency$result, style = "EHDEN") %>%
    #   officer::body_add_par(" ") %>%
    #   officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", vocabResults$sourceConceptFrequency$duration),"초 동안 수행되었습니다.")) %>%
    #   officer::body_add_par("전체 source_to_concept_map 테이블은 결과 압축파일에 추가됩니다.", style="Highlight")

  } else {
    doc<-doc %>%
      officer::body_add_par("> 용어 검사가 실행되지 않았습니다. runVocabularyChecks = TRUE 로 변경하십시오.", style="Highlight") %>%
      officer::body_add_break()
  }

  doc<-doc %>%
    officer::body_add_par(value = "기술적 인프라", style = "heading 1")
  # %>%
  #   officer::body_add_par("> ATLAS, ACHILLES 결과 보고서 도구가 작동하는지 확인하십시오. Atlas 기능은 코호트 설계, 코호트 생성, 간단한 코호트에 대한 특성화 실행 등을 통하여 실제 실행 여부를 검사해야 합니다.", style="Highlight") %>%
  #   officer::body_add_par("> 데이터 소스가 FEEDER-NET 데이터베이스 카탈로그에 추가되었으며, CatalogUeExport 결과가 시각화를 위해 업로드 되었습니까? 또한 이정보를 정기적으로 업데이트하기 위한 프로세스가 합의되었는지 서술하십시오.", style="Highlight") %>%
  #   officer::body_add_par(paste0("> 백업, 재난복구 시스템, ATLAS 호스팅 웹 서버 사양, 테스팅 환경 등과 같은 각 기관 인프라에 대한 정보가 추가적으로 있는 경우 여기에 추가하십시오."), style="Highlight")

  if (!is.null(results$dataTablesResults)) {
    #cdm source
    t_cdmSource <- data.table::transpose(results$cdmSource)
    colnames(t_cdmSource) <- rownames(results$cdmSource)
    field <- colnames(results$cdmSource)
    t_cdmSource <- cbind(field, t_cdmSource)

    colnames(t_cdmSource) <- c("필드명", "내용")
    doc<-doc %>%
      officer::body_add_par(value = "CDM 원본 테이블", style = "heading 2") %>%
      officer::body_add_par("표 8. CDM 원본 테이블 내용") %>%
      my_body_add_table(value =t_cdmSource, style = "EHDEN")
  }

  if (!is.null(results$performanceResults)) {
    #installed packages

    colnames(results$hadesPackageVersions) <- c("패키지명", "버전")

    doc<-doc %>%
      officer::body_add_par(value = "OHDSI HADES 패키지", style = "heading 2") %>%
      officer::body_add_par("표 9. 설치된 모든 HADES R 패키지의 버전") %>%
      my_body_add_table(value = results$hadesPackageVersions, style = "EHDEN")

    if (results$missingPackage=="") {
      doc<-doc %>%
        officer::body_add_par("해당 기관은 현재 모든 HADES 패키지를 사용할 수 있습니다.")
    } else {
      doc<-doc %>%
        officer::body_add_par(paste0("설치되지 않은 HADES 패키지: ",results$missingPackages))
    }

    #system detail
    doc<-doc %>%
      officer::body_add_par(value = "시스템 정보", style = "heading 2") %>%
      officer::body_add_par(paste0("설치된 R 버전: ",results$sys_details$r_version$version.string)) %>%
      officer::body_add_par(paste0("시스템 CPU 제조사: ",results$sys_details$cpu$vendor_id)) %>%
      officer::body_add_par(paste0("시스템 CPU 모델: ",results$sys_details$cpu$model_name)) %>%
      officer::body_add_par(paste0("시스템 CPU 코어 수: ",results$sys_details$cpu$no_of_cores)) %>%
      officer::body_add_par(paste0("시스템 RAM: ",prettyunits::pretty_bytes(as.numeric(results$sys_details$ram)))) %>%
      officer::body_add_par(paste0("데이터베이스 관리시스템 DBMS: ", toupper(results$dms))) %>%
      officer::body_add_par(paste0("WebAPI 버전: ",results$webAPIversion)) %>%
      officer::body_add_par(" ")


    # doc<-doc %>%
    #   officer::body_add_par(value = "용어 쿼리 성능", style = "heading 2") %>%
    #   officer::body_add_par(paste0("'Maps To' 관계의 수는 다음과 같습니다:", results$performanceResults$performanceBenchmark$result,
    #                                ". 해당 쿼리는",sprintf("%.2f", results$performanceResults$performanceBenchmark$duration),"초 동안 수행되었습니다."))
    #
    # doc<-doc %>%
    #   officer::body_add_par(value = "Achilles 쿼리 성능", style = "heading 2") %>%
    #   officer::body_add_par("표 22. Achilles R 패키지 쿼리 수행 시간")

    # if (!is.null(results$performanceResults$achillesTiming$result)) {
    #   doc<-doc %>%
    #     my_body_add_table(value =results$performanceResults$achillesTiming$result, style = "EHDEN") %>%
    #     officer::body_add_par(" ") %>%
    #     officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", results$performanceResults$achillesTiming$duration),"초 동안 수행되었습니다."))
    # } else {
    #   doc<-doc %>%
    #     officer::body_add_par("쿼리가 결과를 반환하지 않았습니다. ", style="Highlight")
    # }


  } else {
    doc<-doc %>%
      officer::body_add_par("성능 검사가 실행되지 않았습니다. runPerformanceChecks = TRUE로 설정하십시오.", style="Highlight") %>%
      body_add_break()
  }
  doc<-doc %>%
    officer::body_add_par(value = "연구 활용 가능성", style = "heading 1") %>%
    officer::body_add_par(paste0("이 항목에는 FEEDER-NET/OHDSI/EHDEN 커뮤니티와의 상호작용 및 매핑 프로세스 후 교육과 관련된 몇 가지 항목이 포함되어 있습니다."))

  colnames(results$cohortCounts) <- c("코호트 번호", "코호트 이름", "레코드 수", "환자 수", "전체 환자 수", "해당 환자 비율 (%)", "쿼리 수행시간 (초)")

  doc<-doc %>%
    officer::body_add_par(value = "연구 샘플 코호트 생성", style = "heading 2") %>%
    officer::body_add_par("표 10. 연구용 샘플 코호트 생성 및 환자 수") %>%
    my_body_add_table(value = results$cohortCounts, style = "EHDEN")

  # doc<-doc %>%
  #   officer::body_add_par(value = "사용자 교육 방안", style = "heading 2") %>%
  #   officer::body_add_par(paste0("해당 기관에서 어떻게 여러 사용자들을 교육하고, 훈련시킬 것 인지에 대하여 서술하십시오. 또한 현재 해당 기관의 CDM 전문성 정도에 대하여 서술하십시오."), style="Highlight")
  #
  # doc<-doc %>%
  #   officer::body_add_par(value = "공동연구 수행 방안", style = "heading 2") %>%
  #   officer::body_add_par(paste0("데이터 파트너가 진행중인 FEEDER-NET/OHDSI/EHDEN 네트워크 연구를 수행할 수 있는지에 대한 방안에 대하여 서술하십시오 (거버넌스 문제, 자원 부족 문제 해결 방안 등을 포함)."), style="Highlight") %>%
  #   officer::body_add_par(paste0("> 공동 연구 주도 및 수행할 계획이 있습니까?"), style="Highlight") %>%
  #   officer::body_add_par(paste0("> OHDSI working 그룹에 참여할 계획이 있습니까?"), style="Highlight")
  #
  # doc <-  doc %>%
  #   body_add_par('품질 관리 방안', style = "heading 1") %>%
  #   officer::body_add_par("> 데이터 품질 대시보드 (Data Quality Dashboard) 결과가 100%임을 확인하십시오. 혹은 품질 인정 기준치가 변경되었는지 확인하십시오.", style="Highlight") %>%
  #   officer::body_add_par("> 기준치가 변경된 이유를 논의하고 이 정보를 공유하여 주십시오.", style="Highlight") %>%
  #   officer::body_add_par("> 데이터 파트너와 함께 Achilles 결과를 검토했습니까?", style="Highlight") %>%
  #   officer::body_add_par("> ETL 코드는 어떻게 테스트하였습니까? 이상적으로는 품질 관리 단계에대하여 논의하거나, 이를 실행하는 코드를 공유하시기를 권합니다. 모든 검토 단계를 통과하였습니까? 예를 들어 원본 자료와 CDM의 사람 수를 비교할 수 있고, 차이에 대하여 충분히 설명되었습니까?", style="Highlight")
  #
  # doc <-  doc %>%
  #   body_add_par('유지 관리 방안', style = "heading 1") %>%
  #   body_add_par("> 새로운 원본 데이터를 사용할 수 있거나, 원본 코드 체계가 업데이트 되었을때, 혹은 새로운 CDM 버전이 출시되었을 때 OMOP CDM의 데이터를 최신 상태로 유지하기 위하여 해당 기관에서 구현한 프로세스를 간략하게 설명하십시오. 또한 이전 CDM 버전을 어떻게 유지할지에 대해서도 서술하십시오.", style="Highlight") %>%
  #   body_add_par("> 분석 및 변환 툴 업데이트를 위해 해당 기관에서 시행한 유지 관리 전략을 서술하시오. ", style="Highlight") %>%
  #   body_add_break()


  doc <-  doc %>%
    body_add_par('부록', style = "heading 1")

  doc<-doc %>%
    officer::body_add_par(value = "[부록 1] Achilles Heel 상세 결과 내역", style = "heading 2")

  if (!is.null(results$performanceResults$achillesHeelResults$result)) {

    colnames(results$performanceResults$achillesHeelResults$result) <- c("분석번호", "규칙번호", "ACHILLES_HEEL_경고", "레코드 수")

    doc<-doc %>%
      my_body_add_table(value =results$performanceResults$achillesHeelResults$result, style = "EHDEN") %>%
      officer::body_add_par(" ") %>%
      officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", results$performanceResults$achillesHeelResults$duration),"초 동안 수행되었습니다.")) %>%
      body_add_break()
  } else {
    doc<-doc %>%
      officer::body_add_par("쿼리가 결과를 반환하지 않았습니다. ", style="Highlight")
  }


  if (!is.null(results$performanceResults$achillesHeelResults$result)) {
  colnames(vocabResults$conceptCounts$result) <- c("ID", "용어체계 이름", "버전", "표준개념", "분류개념", "비표준개념")

  doc<-doc %>%
    officer::body_add_par(value = "[부록 2] OMOP 용어 개념 개수", style = "heading 2") %>%
    officer::body_add_par("표. 해당 CDM 내 가용한 OMOP 용어 개념의 개수. 단, 이는 실제 CDM 테이블 내에서 실제로 사용되는 개념을 반영하지는 않습니다.") %>%
    my_body_add_table(value = vocabResults$conceptCounts$result, style = "EHDEN") %>%
    officer::body_add_par(" ") %>%
    officer::body_add_par(paste("해당 쿼리는",sprintf("%.2f", vocabResults$conceptCounts$duration),"초 동안 수행되었습니다.")) %>%
    body_add_break()

  } else {
    doc<-doc %>%
      officer::body_add_par("쿼리가 결과를 반환하지 않았습니다. ", style="Highlight")
  }


  doc<-doc %>%
    officer::body_add_par(value = "[부록 3] 매핑 / 미매핑 개념 상위 25개 목록", style = "heading 2")

  ## add top 25 mapped codes

  colnames(vocabResults$mappedDrugs$result) <- c("순위", "개념명", "레코드 수 ", "환자 수")
  colnames(vocabResults$mappedConditions$result) <- c("순위", "개념명", "레코드 수 ", "환자 수")
  colnames(vocabResults$mappedMeasurements$result) <- c("순위", "개념명", "레코드 수 ", "환자 수")
  colnames(vocabResults$mappedObservations$result) <- c("순위", "개념명", "레코드 수 ", "환자 수")
  colnames(vocabResults$mappedProcedures$result) <- c("순위", "개념명", "레코드 수 ", "환자 수")
  colnames(vocabResults$mappedDevices$result) <- c("순위", "개념명", "레코드 수 ", "환자 수")

  doc<-doc %>%
    officer::body_add_par(value = "매핑 코드", style = "heading 2")
  my_mapped_section_kor(doc, vocabResults$mappedDrugs, 1, "약물", smallCellCount)
  my_mapped_section_kor(doc, vocabResults$mappedConditions, 2, "진단", smallCellCount)
  my_mapped_section_kor(doc, vocabResults$mappedMeasurements, 3, "검사", smallCellCount)
  my_mapped_section_kor(doc, vocabResults$mappedObservations, 4, "관찰", smallCellCount)
  my_mapped_section_kor(doc, vocabResults$mappedProcedures, 5, "수술 및 처치", smallCellCount)
  my_mapped_section_kor(doc, vocabResults$mappedDevices, 6, "재료 및 기기", smallCellCount)

  ## add Top 25 missing mappings

  colnames(vocabResults$unmappedDrugs$result) <- c("순위", "원본 코드", "레코드 수 ", "환자 수")
  colnames(vocabResults$unmappedConditions$result) <- c("순위", "원본 코드", "레코드 수 ", "환자 수")
  colnames(vocabResults$unmappedMeasurements$result) <- c("순위", "원본 코드", "레코드 수 ", "환자 수")
  colnames(vocabResults$unmappedObservations$result) <- c("순위", "원본 코드", "레코드 수 ", "환자 수")
  colnames(vocabResults$unmappedProcedures$result) <- c("순위", "원본 코드", "레코드 수 ", "환자 수")
  colnames(vocabResults$unmappedDevices$result) <- c("순위", "원본 코드", "레코드 수 ", "환자 수")

  doc<-doc %>%
    officer::body_add_par(value = "미 매핑 개념", style = "heading 2")
  my_unmapped_section_kor(doc, vocabResults$unmappedDrugs, 7, "약물", smallCellCount)
  my_unmapped_section_kor(doc, vocabResults$unmappedConditions, 8, "진단", smallCellCount)
  my_unmapped_section_kor(doc, vocabResults$unmappedMeasurements, 9, "검사", smallCellCount)
  my_unmapped_section_kor(doc, vocabResults$unmappedObservations, 10, "관찰",smallCellCount)
  my_unmapped_section_kor(doc, vocabResults$unmappedProcedures, 11, "수술 및 처치", smallCellCount)
  my_unmapped_section_kor(doc, vocabResults$unmappedDevices, 12, "재료 및 기기", smallCellCount)


  ## save the doc as a word file
  writeLines(paste0("해당 문서를 다음 위치에 저장합니다. ",outputFolder,"/",databaseId,"-results.docx"))
  print(doc, target = paste(outputFolder,"/",databaseId,"-results.docx",sep = ""))
}



