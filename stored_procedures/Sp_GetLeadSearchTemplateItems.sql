IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetLeadSearchTemplateItems]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_GetLeadSearchTemplateItems]
(
    @templateid BIGINT
)
AS
BEGIN
    SELECT 
        LT.TemplateId, 
        LT.TabName,
        (
            SELECT STRING_AGG(CAST(NT.NationalityId AS VARCHAR), '','') 
            FROM (
                SELECT DISTINCT NationalityId 
                FROM NationalityTemplateMapping 
                WHERE TemplateId = LT.TemplateId
            ) AS NT
        ) AS NationalityIds,
        (
            SELECT STRING_AGG(CAST(ST.Sourcetype AS VARCHAR), '','') 
            FROM (
                SELECT DISTINCT Sourcetype 
                FROM SourcetypeTemplateMapping 
                WHERE TemplateId = LT.TemplateId
            ) AS ST
        ) AS SourceIds,
        (
            SELECT STRING_AGG(CAST(CT.CounsellorId AS VARCHAR), '','') 
            FROM (
                SELECT DISTINCT CounsellorId 
                FROM CounsellorTemplateMapping 
                WHERE TemplateId = LT.TemplateId
            ) AS CT
        ) AS CounsellorIds,
        (
            SELECT STRING_AGG(CAST(LST.LeadstatusId AS VARCHAR), '','') 
            FROM (
                SELECT DISTINCT LeadstatusId 
                FROM LeadstatusTemplateMapping 
                WHERE TemplateId = LT.TemplateId
            ) AS LST
        ) AS LeadstatusIds,
        (
            SELECT STRING_AGG(CAST(IT.Interestlevel AS VARCHAR), '','') 
            FROM (
                SELECT DISTINCT Interestlevel 
                FROM InterestlevelTemplateMapping 
                WHERE TemplateId = LT.TemplateId
            ) AS IT
        ) AS InterestIds,
        LT.CreatedDateFrom,
        LT.CreatedDateTo,
        LT.FollowupDateFrom,
        LT.FollowupDateTo
    FROM 
        Tbl_LeadSearchTemplate LT
    WHERE 
        LT.DelStatus = 0 
        AND LT.TemplateId = @templateid;
END
');
END;