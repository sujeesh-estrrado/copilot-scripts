IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_Transport_Registrtion_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Get_Student_Transport_Registrtion_All]             
(            
                
@CurrentPage int = null,            
@PageSize int = null  ,        
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
          
(SELECT    
 distinct TA.Student_Transport_Id as ID,  
           
TA.Student_Employee_Status,  
          
TA.Student_Employee_Id,  
          
TA.RouteStopId,  
          
RD.Route_Id,  
          
RD.Route_Name,   
       
RS.Route_Stop_Name,  
   
TA.Joining_Date,   
      
TA.Leaving_Date,  
        
Vd.Vehicle_Name,  
          
Vd.Vehicle_Number,  
          
SR.Student_Reg_No,  
   
CC.Course_Category_Name+''''-''''+D.Department_Name as [Class],   
             
case when TA.Student_Employee_Status=''''false''''  
             
then             
            
(Select Tbl_Candidate_Personal_Det.Candidate_Fname+'''' ''''+Tbl_Candidate_Personal_Det.Candidate_Mname+'''' ''''+Tbl_Candidate_Personal_Det.Candidate_Lname as CandidateName             
         
 FROM  Tbl_Candidate_Personal_Det    
                   
 where Tbl_Candidate_Personal_Det.Candidate_Id=TA.Student_Employee_Id)  
                     
 end as [Student Name]      
  
,ROW_NUMBER() over (ORDER BY Student_Transport_Id DESC) AS RowNumber   
        
          
FROM  Tbl_Transport_Admission TA    
    
    
LEFT JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id= TA.Student_Employee_Id     
    
left join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id    
                
left join Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id  
                 
left join Tbl_Department D on D.Department_Id=SR.Department_Id     
          
inner join Tbl_Route_Settings RS on RS.Route_Set_Id= TA.RouteStopId   
         
inner join Tbl_RouteDetails RD on RD.Route_Id = RS.Route_Id    
        
inner join Tbl_Vehicle_Route_Mapping VR on VR.Route_Id = RS.Route_Id   
         
inner join Tbl_Vehicle_details Vd on Vd.Vehicle_Id = VR.Vehicle_Id  
  
WHERE Leaving_Date is NULL and Student_Employee_Status=''''false'''' and  
  
  
 (Student_Reg_No like  ''''''+ @SearchTerm+''%''''  
  
or  Candidate_Fname+'''' ''''+Candidate_Mname+'''' ''''+Candidate_Lname like  ''''''+ @SearchTerm+''%''''  
  
or  Course_Category_Name+''''-''''+Department_Name like  ''''''+ @SearchTerm+''%''''         
      
or  Route_Name like  ''''''+ @SearchTerm+''%''''  
  
or  Route_Stop_Name like  ''''''+ @SearchTerm+''%''''   
  
or  Vehicle_Name like  ''''''+ @SearchTerm+''%''''   
  
or  Vehicle_Number like  ''''''+ @SearchTerm+''%''''  
  
or  Route_Stop_Name like  ''''''+ @SearchTerm+''%''''  
  
or  Joining_Date like  ''''''+ @SearchTerm+''%''''  
   
      
)      
      
           
        )                 
            
        SELECT             
 ID,           
 Student_Employee_Status,          
 Student_Employee_Id,          
 RouteStopId,          
 Route_Id,          
 Route_Name,        
 Route_Stop_Name,  
 Joining_Date,        
 Leaving_Date,        
 Vehicle_Name,          
 Vehicle_Number,          
 Student_Reg_No,   
 [Class],           
 [Student Name],             
 RowNumber                                  
        FROM             
            tempProfile where  RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
END      
      
--IF @SearchTerm is null        
      
 IF (@SearchTerm is null or @SearchTerm = '''')      
      
begin      
      
 SET @SqlString=''WITH tempProfile AS            
        (SELECT    
 distinct TA.Student_Transport_Id as ID,  
           
TA.Student_Employee_Status,  
          
TA.Student_Employee_Id,  
          
TA.RouteStopId,  
          
RD.Route_Id,  
          
RD.Route_Name,   
       
RS.Route_Stop_Name,  
   
TA.Joining_Date,   
      
TA.Leaving_Date,  
        
Vd.Vehicle_Name,  
          
Vd.Vehicle_Number,  
          
SR.Student_Reg_No,  
   
CC.Course_Category_Name+''''-''''+D.Department_Name as [Class],   
             
case when TA.Student_Employee_Status=''''false''''  
             
then             
            
(Select Tbl_Candidate_Personal_Det.Candidate_Fname+'''' ''''+Tbl_Candidate_Personal_Det.Candidate_Mname+'''' ''''+Tbl_Candidate_Personal_Det.Candidate_Lname as CandidateName             
         
 FROM  Tbl_Candidate_Personal_Det    
                   
 where Tbl_Candidate_Personal_Det.Candidate_Id=TA.Student_Employee_Id)  
                     
 end as [Student Name]      
  
,ROW_NUMBER() over (ORDER BY Student_Transport_Id DESC) AS RowNumber   
        
          
FROM  Tbl_Transport_Admission TA    
    
    
LEFT JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id= TA.Student_Employee_Id     
    
left join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id    
                
left join Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id  
                 
left join Tbl_Department D on D.Department_Id=SR.Department_Id     
          
inner join Tbl_Route_Settings RS on RS.Route_Set_Id= TA.RouteStopId   
         
inner join Tbl_RouteDetails RD on RD.Route_Id = RS.Route_Id    
        
inner join Tbl_Vehicle_Route_Mapping VR on VR.Route_Id = RS.Route_Id   
         
inner join Tbl_Vehicle_details Vd on Vd.Vehicle_Id = VR.Vehicle_Id  
  
WHERE Leaving_Date is NULL and Student_Employee_Status=''''false''''                                                                                      
                                                                                                        
          
        )                 
            
        SELECT             
    ID,           
 Student_Employee_Status,          
 Student_Employee_Id,          
 RouteStopId,          
 Route_Id,          
 Route_Name,        
 Route_Stop_Name,  
 Joining_Date,        
 Leaving_Date,        
 Vehicle_Name,          
 Vehicle_Number,          
 Student_Reg_No,  
 [Class],            
 [Student Name],             
 RowNumber                                  
        FROM             
            tempProfile  WHERE RowNumber > '' + CONVERT(VARCHAR,@LowerBand) + ''  AND RowNumber < '' + CONVERT(VARCHAR, @UpperBand)      
      
      
end      
      
   EXEC sp_executesql @SqlString            
        
            
    END            
END
    ')
END
