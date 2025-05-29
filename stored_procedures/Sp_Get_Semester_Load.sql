IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Semester_Load]') 
    AND type = N'P'
)
BEGIN
    EXEC('
          
CREATE procedure [dbo].[Sp_Get_Semester_Load]  --1,10,''a''  
            
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
                
    BEGIN                
                 
          
          
IF @SearchTerm IS NOT NULL          
          
BEGIN          
          
 SET @SqlString=''WITH tempProfile AS                
        (SELECT ROW_NUMBER() OVER (ORDER BY Duration_Period_Id) AS RowNumber,Base.*  FROM      
    (SELECT DISTINCT  
       cd.Duration_Period_Id ,       
       cd.Batch_Id            
      ,cd.Semester_Id            
      ,Duration_Period_From            
      ,Duration_Period_To            
      ,Duration_Period_Status            
      ,Semester_Name            
   ,Batch_Code ,    
   Closing_Date,    
   CC.Course_Category_Name +''''-''''+ D.Department_Name as DepartmentName    
         
FROM Tbl_Course_Duration_PeriodDetails cd             
left JOIN Tbl_Course_Batch_Duration bd On cd.Batch_Id=bd.Batch_Id            
left JOIN Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id           
left JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Period_Id=cd.Duration_Period_Id           
left JOIN Tbl_Course_Department Cdep on Cdep.Course_Department_Id=CDM.Course_Department_Id         
left JOIN Tbl_Course_Category CC on CC.Course_Category_Id=Cdep.Course_Category_Id          
left JOIN Tbl_Department D on D.Department_Id=Cdep.Department_Id   ) Base       
          
WHERE  
    
(   Semester_Name like  ''''''+ @SearchTerm +''%''''       
      
or  Batch_Code like  ''''''+ @SearchTerm +''%''''        
    
or  Closing_Date like  ''''''+ @SearchTerm +''%''''       
      
or  DepartmentName like  ''''''+ @SearchTerm +''%''''       
      
or  Duration_Period_From like  ''''''+ @SearchTerm +''%''''    
  
or  Duration_Period_To like  ''''''+ @SearchTerm +''%''''   
  
 )  and  Duration_Period_Status= 0          
               
        )                     
                
        SELECT   
            Duration_Period_Id,     
            Duration_Period_From,                             
            Duration_Period_To,                           
            Semester_Name ,       
            Batch_Code ,   
            Closing_Date ,  
            DepartmentName,  
            Batch_Id,  
            RowNumber                                    
        FROM                 
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
          
          
END          
          
--IF @SearchTerm is null            
          
 IF (@SearchTerm is null or @SearchTerm = '''')          
          
begin          
          
 SET @SqlString=''WITH tempProfile AS                
        (SELECT ROW_NUMBER() OVER (ORDER BY Duration_Period_Id) AS RowNumber,Base.*  FROM      
    (SELECT DISTINCT  
       cd.Duration_Period_Id ,       
       cd.Batch_Id            
      ,cd.Semester_Id            
      ,Duration_Period_From            
      ,Duration_Period_To            
      ,Duration_Period_Status            
      ,Semester_Name            
   ,Batch_Code ,    
   Closing_Date,    
   CC.Course_Category_Name +''''-''''+ D.Department_Name as DepartmentName    
         
FROM Tbl_Course_Duration_PeriodDetails cd             
left JOIN Tbl_Course_Batch_Duration bd On cd.Batch_Id=bd.Batch_Id            
left JOIN Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id        
left JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Period_Id=cd.Duration_Period_Id           
left JOIN Tbl_Course_Department Cdep on Cdep.Course_Department_Id=CDM.Course_Department_Id         
left JOIN Tbl_Course_Category CC on CC.Course_Category_Id=Cdep.Course_Category_Id          
left JOIN Tbl_Department D on D.Department_Id=Cdep.Department_Id   ) Base       
          
WHERE   Duration_Period_Status= 0             
               
        )                     
                
        SELECT   
            Duration_Period_Id,    
            Duration_Period_From,                             
            Duration_Period_To,                           
            Semester_Name ,       
            Batch_Code ,   
            Closing_Date ,  
            DepartmentName,  
            Batch_Id,  
            RowNumber                                     
        FROM                 
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
          
          
end          
          
   EXEC sp_executesql @SqlString                
            
                
    END                
END

');
END;