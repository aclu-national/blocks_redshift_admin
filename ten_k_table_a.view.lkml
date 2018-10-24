view: ten_k_table_a {
  derived_table: {
    sql: SELECT o.accountid, a.account_number__c, a.sort_name__c, a.affiliation__c, SUM(o.amount)  as Sum_of_Giving,
      CASE WHEN Sum_of_Giving >= '2500000' then 'a.25000000_plus'
      WHEN Sum_of_Giving >= '1000000' then 'b.1000000_to_2499999'
      WHEN Sum_of_Giving >= '500000' then 'c.500000_to_999999'
      WHEN Sum_of_Giving >= '250000' then 'd.250000_to_499999'
      WHEN Sum_of_Giving >= '100000' then 'e.100000_to_249999'
      WHEN Sum_of_Giving >= '50000' then 'f.50000_to_99999'
      WHEN Sum_of_Giving >= '25000' then 'g.25000_to_49999'
      WHEN Sum_of_Giving >= '10000' then 'h.10000_to_24999'
      ELSE 'NA' end as Category_of_Donor
      FROM  sf.account a
      JOIN sf.opportunity o on o.accountid = a.id
      where o.closedate BETWEEN '04/01/2017' and '03/31/2018'
      and o.sharing_code__c NOT IN ('U001','U002','U003','U004','U005','Q001','Q002','Q003','Q004','Q005', 'R141', 'E141')
      and o.recordtypeid  IN('01236000000fBmOAAU', '01236000000OgkDAAS', '01236000000fBnUAAU')
      and a.account_type__c IN ('Donor Advised Fund', 'Family Foundation', 'Foundation', 'Household', 'Individual')
      And o.adjustment_code__c IN('D','N')
      and o.stagename = 'Completed'
      GROUP BY o.accountid, a.account_number__c, a.sort_name__c, a.affiliation__c
      HAVING sum_of_giving >= 10000
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: accountid {
    type: string
    sql: ${TABLE}.accountid ;;
  }

  dimension: account_number__c {
    type: string
    sql: ${TABLE}.account_number__c ;;
  }

  dimension: sort_name__c {
    type: string
    sql: ${TABLE}.sort_name__c ;;
  }

  dimension: affiliation__c {
    type: string
    sql: ${TABLE}.affiliation__c ;;
  }

  dimension: sum_of_giving {
    type: number
    sql: ${TABLE}.sum_of_giving ;;
  }

  dimension: category_of_donor {
    type: string
    sql: ${TABLE}.category_of_donor ;;
  }

  set: detail {
    fields: [
      accountid,
      account_number__c,
      sort_name__c,
      affiliation__c,
      sum_of_giving,
      category_of_donor
    ]
  }
}
