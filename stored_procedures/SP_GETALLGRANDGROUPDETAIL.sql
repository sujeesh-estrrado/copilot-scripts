IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GETALLGRANDGROUPDETAIL]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_GETALLGRANDGROUPDETAIL] 
(@grandgroupid bigint)    
    
AS BEGIN    
    
SELECT ggc.GrandGroupCodeId,ggc.GrandGroupCode,ggc.GrandGroupDesc,id.EffectiveFromDate,id.DateTo,id.IncentiveTypeId,    
id.IncentiveAmount,id.IncentiveSchemeCode,gc.GroupCourseCode,gc.GroupCourseCodeId,id.IncentiveId,iggm.GrandGroupInceMapId 
from     
Tbl_Grand_Group ggc inner join  dbo.Tbl_Incentive_GrandGroupMap iggm on iggm.GrandGroupCodeId=ggc.GrandGroupCodeId    
inner join dbo.Tbl_Incentive_Details id on id.IncentiveId=iggm.IncentiveId    
inner join dbo.Tbl_Group_Course gc on gc.GroupCourseCodeId=iggm.GroupCourseCodeId    
    
where ggc.GrandGroupCodeId=@grandgroupid  and ggc.delstatus=0
     
END

    ')
END
GO
