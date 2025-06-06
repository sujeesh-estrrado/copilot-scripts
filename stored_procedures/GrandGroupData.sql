IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GrandGroupData]') 
    AND type = N'P'
)
BEGIN
    EXEC sp_executesql N'
   CREATE procedure [dbo].[GrandGroupData]  --1,10,''''            
(                             
@CurrentPage int=null ,                     
@PageSize int=null   ,                  
@SearchTerm varchar(100)                        
)                          
                              
AS              
                                                                 
BEGIN                          
    SET NOCOUNT ON                          
                          
    DECLARE @SqlString nvarchar(max)                      
    Declare @SqlStringWithout nvarchar(max)                          
    Declare @UpperBand int                          
    Declare @LowerBand int                                  
                              
    SET @LowerBand  = (@CurrentPage - 1) * @PageSize                          
    SET @UpperBand  = (@CurrentPage * @PageSize) + 1                              
                          
    --BEGIN                      
 IF @SearchTerm IS NOT NULL                    
                    
BEGIN                    
                    
 SET @SqlString=''WITH tempProfile AS  (SELECT ROW_NUMBER() OVER (ORDER BY GrandGroupCodeId desc) as num,Base.*  FROM                
    (SELECT DISTINCT            
    GrandGroupCodeId,          
    GrandGroupCode,          
    GrandGroupDesc         
    from Tbl_Grand_Group WHERE delstatus=0 ) Base  where       
    ( GrandGroupCode like  ''''''+ @SearchTerm +''%''''       
    or GrandGroupDesc  like  ''''''+ @SearchTerm +''%'''' )      
          
)             
select           
   GrandGroupCodeId,          
    GrandGroupCode,          
    GrandGroupDesc,      
    num         
           
  from tempProfile where num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)               
            
  END          
                      
 IF (@SearchTerm is null or @SearchTerm = '''')                    
                    
begin           
      
SET @SqlString=''WITH tempProfile AS  (SELECT ROW_NUMBER() OVER (ORDER BY GrandGroupCodeId desc) as num,Base.*  FROM                
    (SELECT DISTINCT            
    GrandGroupCodeId,          
    GrandGroupCode,          
    GrandGroupDesc              
    from Tbl_Grand_Group  WHERE delstatus=0) Base            
   )          
    select           
    GrandGroupCodeId,          
    GrandGroupCode,          
    GrandGroupDesc,      
    num         
           
  from tempProfile where num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)                
         
       end        
     EXEC sp_executesql @SqlString                          
         
  end';
END;
