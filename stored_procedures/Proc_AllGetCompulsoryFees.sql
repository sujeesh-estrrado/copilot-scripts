IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AllGetCompulsoryFees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_AllGetCompulsoryFees] --1,10,''CERTIFICATE IN OFFICE SKILLS''              
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
                            
    BEGIN                   
                  
    IF @SearchTerm IS NOT NULL                      
                      
BEGIN          
        
 SET @SqlString=''WITH tempProfile AS  (SELECT ROW_NUMBER() OVER (ORDER BY CompulsoryFeeId DESC) AS num,Base.*  FROM       
      
(select c.*,d.Department_Name,c.TypeOfStudent typestu from dbo.Tbl_Fee_Compulsory c inner join     
Tbl_Department d on d.Department_Id=c.CourseId          
  )Base      
       
  WHERE               
 ( Department_Name like  ''''''+ @SearchTerm+''%''''    
 or TypeOfStudent like  ''''''+ @SearchTerm+''%''''    
 or  validity like  ''''''+ @SearchTerm+''%'''')                   
           
    )    
         
 select         
     CompulsoryFeeId,         
     Department_Name,        
     TypeOfStudent,        
     validity,         
     num        
             
     FROM                             
            tempProfile where  num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)                 
                      
                          
END              
        
IF (@SearchTerm is null or @SearchTerm = '''')                      
                      
begin        
SET @SqlString=''WITH tempProfile AS     
(SELECT ROW_NUMBER() OVER (ORDER BY CompulsoryFeeId DESC) AS num,Base.*  FROM       
      
(select c.*,d.Department_Name,c.TypeOfStudent typestu from dbo.Tbl_Fee_Compulsory c inner join     
Tbl_Department d on d.Department_Id=c.CourseId          
  )Base    
    
         )    
      select       
     CompulsoryFeeId,         
     Department_Name,        
     TypeOfStudent,        
     validity,         
     num     
         
     FROM                             
            tempProfile where  num > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND num < '' + CONVERT(VARCHAR, @UpperBand)                 
                
        end        
         EXEC sp_executesql @SqlString                            
                        
                            
    END         
    end
    ')
END;
