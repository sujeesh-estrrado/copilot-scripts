IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[selectintakefecodemap_all]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
          
CREATE procedure [dbo].[selectintakefecodemap_all] --1,10,''PTPTN--FEE--2016-2016''      
(              
@CurrentPage int=null,              
@PageSize int=null,              
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
                            
                       
                  
       
IF @SearchTerm IS NOT NULL                      
                      
BEGIN          
        
 SET @SqlString=''WITH tempProfile AS              
 (SELECT ROW_NUMBER() OVER (ORDER BY InakeFeecodeMapID DESC) AS num,Base.*  FROM           
(select I.*,C.Batch_Code from Tbl_IntakeFeecodeMap I inner join Tbl_Course_Batch_Duration C on I.IntakeId=C.Batch_Id)      
Base        
WHERE                 
 ( Batch_Code like  ''''''+ @SearchTerm+''%'''' or       
 FeeCode like  ''''''+ @SearchTerm+''%'''')      
       
 )      
       
 select    
 InakeFeecodeMapID,     
 IntakeId,      
 Batch_Code,      
 FeeCode,      
 num      
       
FROM                             
            tempProfile where  num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)                 
                                     
END         
      
IF (@SearchTerm is null or @SearchTerm = '''')                      
                      
begin        
      
 SET @SqlString=''WITH tempProfile AS              
 (SELECT ROW_NUMBER() OVER (ORDER BY InakeFeecodeMapID DESC) AS num,Base.*  FROM           
(select I.*,C.Batch_Code from Tbl_IntakeFeecodeMap I inner join Tbl_Course_Batch_Duration C on I.IntakeId=C.Batch_Id)      
Base      
      
)         
      
 select    
 InakeFeecodeMapID,    
 IntakeId,       
 Batch_Code,      
 FeeCode,      
 num        
       
 FROM                             
            tempProfile where  num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)                 
                
        end        
         EXEC sp_executesql @SqlString                            
                        
                            
    END
    ');
END;
