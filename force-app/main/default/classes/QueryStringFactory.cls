/*********************************************************************************
* Class :          QueryStringFactory
* Test Class :     QueryStringFactoryTest
* Created By :     Amit Singh
-----------------------------------------------------------------------------------
* Description : Class to generate the soql query String
-----------------------------------------------------------------------------------
* Version History:
* Version    Developer Name    Date          Detail Features
* 1.0        Amit              19/07/2022    Initial Development
*
***********************************************************************************/

/********************************
    Set fields = new Set {'Id', 'Name', 'Phone', 'AccountNumber', 'Custom_Field__c'};
    QueryStringFactory.isUpdateable = true;
    QueryStringFactory.FilterClauseWrapper wrap = new QueryStringFactory.FilterClauseWrapper();
    wrap.filterLogic = '({0})';
    wrap.filters = new Set {'Phone != null'};
    QueryStringFactory.isRecordLocking = true;
    QueryStringFactory.isSecurityEnforced = true;
    QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    qsf.addLimit(1);
    qsf.addInnerQuery(new Set {'(Select Id, Name from Contacts)'});
    qsf.addWhereClause(wrap, false);
    qsf.addOffSet(0);
    String query = qsf.query();
    system.debug('== Final query String '+query);
 */

public with sharing class QueryStringFactory {
    
    /*
    *  Constant variables
    */
    public final String SELECT_CLAUSE            = 'SELECT ';
    public final String FROM_CLAUSE              = ' FROM ';
    public final String ID_FROM_CLAUSE           = 'Id FROM ';
    public final String ID_FIELD                 = ' Id ';
    public final String WHERE_CLAUSE             = ' WHERE ';
    public final String ALL_ROWS                 = ' ALL ROWS ';
    public final String GROUP_BY                 = ' GROUP BY ';
    public final String HAVING_CLAUSE            = ' HAVING ';
    public final String ORDER_BY                 = ' ORDER BY ';
    public final String LIMIT_CLAUSE             = ' LIMIT ';
    public final String OFFSET_CLAUSE            = ' OFFSET ';
    public final String WITH_SECURITY_ENFORCED   = ' WITH SECURITY_ENFORCED ';
    public final String FOR_UPDATE               = ' FOR UPDATE ';
    public final String STANDARD_FIELD           = ' FIELDS(STANDARD) ';
    public final String STANDARD_FIELD_WITH_FROM = ' FIELDS(STANDARD) FROM ';
    public final String ASCENDING                = ' ASC ';
    public final String DESCENDING               = ' DESC ';
    public final String EMPTY_String             = '';
    public final String SOQL_QUERY_LIMIT_EXCEED  = 'You have reached the maximum no of SOQL query in single transaction.';

    public final String COMMA                    = ',';

    public static Boolean isUpdateable           = false;
    public static Boolean isRecordLocking        = false;
    public static Boolean isSecurityEnforced     = false;

    public String objectName;

    public String queryString = SELECT_CLAUSE;

    public QueryDetails qd;

    
    /*
    *  Parameter : 'objectApiName' - We need to set the sObject API Name.
    *  Example : QueryStringFactory qsf = new QueryStringFactory('Account');
    *  Return : null
    *  Description : Method will take Object API Name as parameter and constract a query with Id field only.
    */
    public QueryStringFactory(String objectApiName) {
        qd = new QueryDetails();
        
        if(String.isNotBlank(objectApiName)){
            qd.objectName = objectApiName;
            qd.fields     = ID_FIELD;
        }
    }
    
    /*
    *  Parameter : 'objectApiName' - We need to set the sObject API Name, 'setOfFields' - Set<String> fields = new Set<String> {'Name'};
    *  Example : QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *  Return : null
    *  Description : Method will take Object API Name as parameter and construct a query with Set of fields from second parameter.
    */
    public QueryStringFactory(String objectApiName, Set<String> setOfFields) {
        qd = new QueryDetails();
        qd.objectName = objectApiName;

        if(String.isNotBlank(objectApiName) && setOfFields != null){
            qd.fields = joinToString(setOfFields, COMMA);
            /*
            if(isUpdateable){
                set<String> updatableFields = new set<String>();
                for(SObjectField field : Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().values()){
                    Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                    if(setOfFields.contains(fieldDesc.getName()) && fieldDesc.isUpdateable()){
                        updatableFields.add(fieldDesc.getName());
                    }
                }
                qd.fields = joinToString(updatableFields, COMMA);
            }else{
                qd.fields = joinToString(setOfFields, COMMA);
            }
            */
        }
        
    }
    
    
    /*
    *  Parameter : 'objectApiName' - We need to set the sObject API Name, 'standardFields' - if need to include all the standard fields, 'customFields' - if need to include all the custom fields
    *  Example : QueryStringFactory qsf = new QueryStringFactory('Account', true, true);
    *  Return : null
    *  Description : Method will take Object API Name as a first parameter and second parameter to include all standard field and third parameter is used to inculde all custom fields in query.
    */
    public QueryStringFactory(String objectApiName, Boolean standardFields, Boolean customFields) {
        qd = new QueryDetails();
        qd.objectName = objectApiName;

        String allCustomField = '';
        if(String.isNotBlank(objectApiName) && customFields){
            set<String> allCustomeFieldSet = new set<String>();
            for(SObjectField field : Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap().values()){
                Schema.DescribeFieldResult fieldDesc = field.getDescribe();
                if (fieldDesc.isCustom()) {
                    if(isUpdateable && fieldDesc.isUpdateable()){
                        allCustomeFieldSet.add(fieldDesc.getName());
                    }else{
                        allCustomeFieldSet.add(fieldDesc.getName());
                    }
                }
            }
            if(!allCustomeFieldSet.isEmpty()){
                allCustomField = joinToString(allCustomeFieldSet, COMMA);
            }
        }
        if(String.isNotBlank(objectApiName) && standardFields && customFields && String.isNotBlank(allCustomField)){

            qd.fields = STANDARD_FIELD + COMMA + allCustomField;
        }else if(String.isNotBlank(objectApiName) && standardFields && !customFields){

            qd.fields = STANDARD_FIELD;
        }else if(String.isNotBlank(objectApiName) && !standardFields && customFields){

            qd.fields = allCustomField;
        }else if(String.isNotBlank(objectApiName) && !standardFields && !customFields){

            qd.fields = ID_FIELD;
        }
    }
    
    /*
    *  Parameter : 'innerQuerySet' - we need to set the set of String as inner query format.
    *  Example : Set<String> fields = new Set<String> {'Name'};
    *            QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *            qsf.addInnerQuery(new Set<String> {'(Select Id, Name from Contacts)'});
    *  Return : null
    *  Description : Method will take set of String parameter as input and add them to inner query.
    */
    public void addInnerQuery(Set<String> innerQuerySet){
        if(!innerQuerySet.isEmpty()){
            qd.innerQuery = COMMA + joinToString(innerQuerySet, COMMA);
        }
    }
    
    
    /*
    *  Parameter : 'whereClauseData' - Instance of FilterClauseWrapper wrapper class and 'includeDeletedRecords' - if need to fetch the records from recycle bin.
    *  Example : QueryStringFactory.FilterClauseWrapper wrap = new QueryStringFactory.FilterClauseWrapper();
    *            wrap.filterLogic = '({0})';
    *            wrap.filters = new Set<String> {'Phone != null'};
    *            Set<String> fields = new Set<String> {'Name'};
    *            QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *            qsf.addWhereClause(wrap, false);
    *  Return : null
    *  Description : Method is used to construct a where clause of a query.
    */
    public void addWhereClause(FilterClauseWrapper whereClauseData, Boolean includeDeletedRecords){
        
        if(whereClauseData != null && whereClauseData.filterLogic != null && whereClauseData.filters != null){

            String whereClause = String.format(whereClauseData.filterLogic, new List<String>(whereClauseData.filters));
            qd.whereClause = whereClause;
            qd.includeDeletedRecords = includeDeletedRecords;
        }

        if(includeDeletedRecords){
            queryString +=  ALL_ROWS;
        }
    }
    
    /*
    *  Parameter : 'setOfFields' - set of fields with which we need to do group by.
    *  Example : 
    *            Set<String> fields = new Set<String> {'Name'};
    *            QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *            qsf.addGroupBy(new Set<String> {'Name'});
    *  Return : null
    *  Description : Method is used to add a Group By clause in a query.
    */
    public void addGroupBy(Set<String> setOfFields){
        qd.groupBy = joinToString(setOfFields, COMMA);
    }
    
    /*
    *  Parameter : 'havingClauseData' - Instance of FilterClauseWrapper wrapper class.
    *  Example : QueryStringFactory.FilterClauseWrapper wrap = new QueryStringFactory.FilterClauseWrapper();
    *            wrap.filterLogic = '({0})';
    *            wrap.filters = new Set<String> {'Industry != null'};
    *            Set<String> fields = new Set<String> {'Industry', 'COUNT(Id)'};
    *            QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *            qsf.addGroupBy(new Set<String> {'Industry'});
    *            qsf.addHavingClause(wrap);
    *  Return : null
    *  Description : Method is used to add a Having clause in a query.
    */
    public void addHavingClause(FilterClauseWrapper havingClauseData){
        if(havingClauseData != null && havingClauseData.filterLogic != null && havingClauseData.filters != null){

            String havingClause = String.format(havingClauseData.filterLogic, new List<String>(havingClauseData.filters));
            qd.havingClause = havingClause;
        }
    }
    
    /*
    *  Parameter : 'isASC' - get the record in Ascending order, 'isDESC' - get the record in descending order, 'setOfFields' - get the record with 
    *  Example : Set<String> fields = new Set<String> {'Name'};
    *            QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *            qsf.addOrderBy(false, true, new Set<String> {'Name'});
    *  Return : null
    *  Description : Method is used to add a Order By clause in a query.
    */
    public void addOrderBy(Boolean isASC, Boolean isDESC, Set<String> setOfFields){
        qd.orderBy = joinToString(setOfFields, COMMA) + (isASC ? ASCENDING : EMPTY_String) + (isDESC ? DESCENDING : EMPTY_String);
    }
    
    
    /*
    *  Parameter : 'numberOfRowsToReturn' - no of record that the return from SOQL query (If available)
    *  Example : Set<String> fields = new Set<String> {'Name'};
    *            QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *            qsf.addLimit(1);
    *  Return : null
    *  Description : Method is used to add a Limit in a query.
    */
    public void addLimit(Integer numberOfRowsToReturn){
        qd.limitClause = EMPTY_String + numberOfRowsToReturn;
    }
    
    /*
    *  Parameter : 'numberOfRowsToSkip' - no of record that we want to skip from the return result
    *  Example : Set<String> fields = new Set<String> {'Name'};
    *            QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *            qsf.addOffSet(5);
    *  Return : null
    *  Description : Method is used to add a Offset in a query.
    */
    public void addOffSet(Integer numberOfRowsToSkip){
        qd.offSetClause = EMPTY_String + numberOfRowsToSkip;
    }
    
    
    /*
    *  Parameter : 
    *  Example : Set<String> fields = new Set<String> {'Name'};
    *            QueryStringFactory qsf = new QueryStringFactory('Account', fields);
    *            qsf.query();
    *  Return : 'SELECT ID, Name from Account'
    *  Description : Method is used to construct a query String with all specified values.
    */
    public String query(){

        String query = SELECT_CLAUSE + qd.fields;

        if(String.isNotBlank(qd.innerQuery)){
            query += qd.innerQuery;
        }

        query += FROM_CLAUSE + qd.objectName;

        if(String.isNotBlank(qd.whereClause)){
            query += WHERE_CLAUSE + qd.whereClause;
        }

        if(isSecurityEnforced){
            query += WITH_SECURITY_ENFORCED;
        }

        if(String.isNotBlank(qd.groupBy)){
            query += GROUP_BY + qd.groupBy;
        }
        
        if(String.isNotBlank(qd.havingClause)){
            query += HAVING_CLAUSE + qd.havingClause;
        }

        if(String.isNotBlank(qd.orderBy)){
            query += ORDER_BY + qd.orderBy;
        }

        if(String.isNotBlank(qd.limitClause)){
            query += LIMIT_CLAUSE + qd.limitClause;
        }

        if(String.isNotBlank(qd.offSetClause)){
            query += OFFSET_CLAUSE + qd.offSetClause;
        }

        if(isRecordLocking && String.isBlank(qd.groupBy) && String.isBlank(qd.havingClause)){
            query += FOR_UPDATE;
        }

        if(qd.includeDeletedRecords && !isRecordLocking){
            query += ALL_ROWS;
        }
        
        if(Limits.getQueries() >= Limits.getLimitQueries()){
            
            return SOQL_QUERY_LIMIT_EXCEED;
        }
        
        return String.isNotBlank(query) ? query : null;
    }

    /*
    *  Method is used to join a set of String with Join keyword
    */
    public String joinToString(set<String> setOfStringValues, String joinKeyword){
        return String.join(new List<String>(setOfStringValues), joinKeyword);
    }

    public class FilterClauseWrapper {

        public String filterLogic;
        public set<String> filters;
    }

    public class QueryDetails {

        public String objectName;
        public String fields;
        public String innerQuery;
        public String whereClause;
        public String groupBy;
        public String havingClause;
        public String orderBy;
        public String limitClause;
        public String offSetClause;

        public boolean includeDeletedRecords;

    }

}