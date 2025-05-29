IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetGradeByPersentageAndID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetGradeByPersentageAndID]     
(@Grade bigint=0,@total decimal(18,2)=0)      
as      
begin      
if(@total>100)      
begin      
select * from Tbl_GradeSchemeSetup where Grade_Scheme_Id=@Grade and (([From] <=100  and [To]>=100))      
end     
if(@total=0)    
begin     
select * from Tbl_GradeSchemeSetup where Grade_Scheme_Id=@Grade    
end    
else      
begin      
      
select *,Grade_Sheme_Setup_Id,Pass from Tbl_GradeSchemeSetup where Grade_Scheme_Id=@Grade and (([From] <=@total  and [To]>=@total))      
end      
end
');
END;