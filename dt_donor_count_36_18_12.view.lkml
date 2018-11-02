view: dt_donor_count_36_18_12 {
  derived_table: {
    sql: SELECT m.Affil
      ,m.Category
      ,m.Running_Counting_Joint_2 AS "Counting Joint = 2"
      ,m.Running_Total_Records AS "Total Records"
FROM
(

SELECT Affil
      ,CASE WHEN MinRange = 15 THEN 'Donors 15 Months'
            WHEN MinRange = 18 THEN 'Donors 18 Months'
            WHEN MinRange = 24 THEN 'Donors 24 Months'
            WHEN MinRange = 36 THEN 'Donors 36 Months'
       END AS Category
      ,Total_Records
      ,SUM(Total_Records) OVER (PARTITION BY Affil ORDER BY MinRange ROWS unbounded preceding) AS Running_Total_Records
      ,Person_Count
      ,SUM(Person_Count)  OVER (PARTITION BY Affil ORDER BY MinRange ROWS unbounded preceding) AS Running_Counting_Joint_2
  FROM (
SELECT d.Affil
      ,d.MinRange
      ,COUNT(*) AS Total_Records
      ,SUM(CASE
             WHEN (SELECT COUNT(*)
                   FROM sf.preference p
                   WHERE d.AccountId = p.rC_Bios__Account__c
                   AND p.rC_Bios__Code_Value__c = 'AJ'
                   AND p.rC_Bios__Active__c = 'true'
                   ) > 0 THEN
               2
             ELSE
               1
           END) Person_Count
  FROM (SELECT d.AccountId
              ,SUBSTRING(a.Affiliation__c,1,2) AS Affil
              ,MIN(CASE
                     WHEN MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 15 THEN 15
                     WHEN MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 18 THEN 18
                     WHEN MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 24 THEN 24
                     WHEN MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 36 THEN 36
                     ELSE
                       0
                   END) MinRange
          FROM sf.opportunity d INNER JOIN sf.account a ON a.Id = d.AccountId
          WHERE d.RecordTypeId IN ('01236000000fBnUAAU','01236000000OgkDAAS','01236000000fBmOAAU')
          AND d.stageName = 'Completed'
          AND d.Exclude_from_Revenue_Sharing__c = 'false'
          AND MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 36
          AND d.Deposit_Site__c <> 'COS*'
          AND d.Amount > 0
          AND d.Adjustment_Code__c in ('D','N')

          GROUP BY d.AccountId, a.Affiliation__c
          ) d
  WHERE (SELECT COUNT(*)
         FROM sf.preference p
         WHERE d.AccountId = p.rC_Bios__Account__c
         AND p.rC_Bios__Code_Value__c IN ('ZD','ZN')
         AND p.rC_Bios__Active__c = 'true'
         ) = 0
    AND EXISTS (SELECT 1
                FROM sf.contact c
                WHERE d.AccountId = c.accountid
                AND c.rc_bios__active__c = 'true'
                AND c.rc_bios__deceased__c = 'false'
                )

  GROUP BY Affil, MinRange
  ORDER BY Affil, MinRange) d

 UNION ALL

SELECT Affil
      ,CASE
         WHEN MinRange = 15 THEN 'Members 15 Months'
         WHEN MinRange = 18 THEN 'Members 18 Months'
         WHEN MinRange = 24 THEN 'Members 24 Months'
         WHEN MinRange = 36 THEN 'Members 36 Months'
       END AS Category
      ,Total_Records
      ,SUM(Total_Records) OVER (PARTITION BY Affil ORDER BY MinRange ROWS unbounded preceding) AS Running_Total_Records
      ,Person_Count
      ,SUM(Person_Count)  OVER (PARTITION BY Affil ORDER BY MinRange ROWS unbounded preceding) AS Running_Counting_Joint_2
  FROM (
SELECT d.Affil
      ,d.MinRange
      ,COUNT(*) AS Total_Records
      ,SUM(CASE
             WHEN (SELECT COUNT(*)
                   FROM sf.preference p
                   WHERE d.AccountId = p.rC_Bios__Account__c
                   AND p.rC_Bios__Code_Value__c = 'AJ'
                   AND p.rC_Bios__Active__c = 'true'
                   ) > 0 THEN
               2
             ELSE
               1
           END) Person_Count
  FROM (SELECT d.AccountId
              ,SUBSTRING(a.Affiliation__c,1,2) AS Affil
              ,MIN(CASE
                     WHEN MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 15 THEN 15
                     WHEN MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 18 THEN 18
                     WHEN MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 24 THEN 24
                     WHEN MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 36 THEN 36
                     ELSE
                       0
                   END) MinRange
          FROM sf.opportunity d INNER JOIN sf.account a ON a.Id = d.AccountId
          WHERE d.RecordTypeId IN ('01236000000fBnUAAU','01236000000OgkDAAS','01236000000fBmOAAU')
          AND d.stageName = 'Completed'
          AND d.Exclude_from_Revenue_Sharing__c = 'false'
          AND MONTHS_BETWEEN(LAST_DAY(CURRENT_DATE - INTERVAL '1 MONTH'),d.CloseDate) BETWEEN 0 AND 36
          AND d.Sharing_Code__c IN ('E181','E131','B003','A001','A002','A003','P001','P002','P003','D009','D011','D012')
          AND d.Deposit_Site__c <> 'COS*'
          AND d.Amount >= 5
          AND d.Adjustment_Code__c in ('D','N')

          GROUP BY d.AccountId, a.Affiliation__c

        UNION

          SELECT pl.rC_Bios__Account__c AS AccountId
                ,SUBSTRING(a.Affiliation__c,1,2) AS Affil
                ,15
          FROM sf.preference pl INNER JOIN sf.account a ON a.Id = pl.rc_bios__account__c
          WHERE pl.rC_Bios__Code_Value__c = 'AL'
          AND pl.rC_Bios__Active__c = 'true'
          ) d
  WHERE (SELECT COUNT(*)
         FROM sf.preference p
         WHERE d.AccountId = p.rC_Bios__Account__c
         AND p.rC_Bios__Code_Value__c IN ('ZD','ZN')
         AND p.rC_Bios__Active__c = 'true'
         ) = 0
    AND EXISTS (SELECT 1
                FROM sf.contact c
                WHERE d.AccountId = c.accountid
                AND c.rc_bios__active__c = 'true'
                AND c.rc_bios__deceased__c = 'false'
                )
  GROUP BY Affil, MinRange
  ORDER BY Affil, MinRange) m
) m
ORDER BY m.Affil ASC, m.Category DESC
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

measure: sum_of_sum_of_members{
  type: sum
  sql: ${total_records} ;;
}
  dimension: affil {
    type: string
    sql: ${TABLE}.affil ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: counting_joint__2 {
    type: number
    label: "counting joint = 2"
    sql: ${TABLE}."counting joint = 2" ;;
  }

  dimension: total_records {
    type: number
    label: "total records"
    sql: ${TABLE}."total records" ;;
  }

  set: detail {
    fields: [affil, category, counting_joint__2, total_records]
  }
}
