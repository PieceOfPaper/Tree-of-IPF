
function GET_JOB_SELECT_GUIDE_ANSWER_LIST(ctrlType, question)
    local list1 = FIND_CLASSNAME_LIST_BY_PROP("ClassSelectGuide_Question", "CtrlType", ctrlType);
    local list2 = FIND_CLASSNAME_LIST_BY_PROP("ClassSelectGuide_Question", "QuestionGroup", question);
    local intersectList = GET_INTERSECT_TABLE_BY_VALUE(list1, list2);
    return intersectList;
end

function INIT_JOB_SELECT_GUIDE_JOB_STACK(ctrlType)
    local list = {}
    list[#list + 1] = FIND_CLASSNAME_LIST_BY_PROP("ClassSelectGuide", "CtrlType", ctrlType);
    return list;
end

function GET_JOB_SELECT_GUIDE_QUESTIONS(ctrlType)
    if ctrlType == nil then
        IMC_LOG("INFO_NORMAL", "assert");
        return;
    end
    local ctrlClsList = FIND_CLASSNAME_LIST_BY_PROP("ClassSelectGuide_Question", "CtrlType", ctrlType);
    local questionList = {};
    local questionHash = {};
    for i=1, #ctrlClsList do
        local cls = GetClass("ClassSelectGuide_Question", ctrlClsList[i]);
        if questionHash[cls.QuestionGroup] == nil then
            questionList[#questionList + 1] = { GROUP_NAME = cls.QuestionGroup, QUESTION_CLS_LIST = {} };
            questionHash[cls.QuestionGroup] = questionList[#questionList];
        end
        local qnaList = questionHash[cls.QuestionGroup]["QUESTION_CLS_LIST"];
        qnaList[#qnaList + 1] = {CLS_NAME = cls.ClassName, JOB_LIST = GET_JOB_SELECT_GUIDE_JOB_LIST_BY_QUESTION(cls)};
    end
    return questionList;
end


function GET_JOB_SELECT_GUIDE_JOB_LIST_BY_QUESTION(questionCls)
    local list = {};

    local answerClsList = FIND_CLASSNAME_LIST_BY_PROP("ClassSelectGuide", "CtrlType", questionCls.CtrlType);
    for i=1, #answerClsList do
        local jobName = answerClsList[i];
        local answerCls = GetClass("ClassSelectGuide", jobName);
        if answerCls[questionCls.Question] == questionCls.AnswerValue then
            list[#list + 1] = jobName;
        end
    end

    return list;
end

function GET_JOB_SELECT_GUIDE_CARD_POSITION(count, cardWidth, cardHeight, bgWidth, bgHeight, distX, distY, maxOneLineCnt)
    if count >= 10 then
        IMC_LOG("INFO_NORMAL", "assert");
    end
    
    local firstColCount = math.floor(count / 2) + count%2;
    if count <= maxOneLineCnt then
        firstColCount = count;
    end
    local secondColCount = count - firstColCount;

    local rowCount = 2;
    if secondColCount <= 0 then
        rowCount = 1;
    end

    local ret = {};
    for i=1, firstColCount do
        ret[#ret + 1] = {};
        ret[#ret]["x"] = CALC_CENTER_ALIGN_POSITION(i, firstColCount, cardWidth, distX, bgWidth)
        ret[#ret]["y"] = CALC_CENTER_ALIGN_POSITION(1, rowCount, cardHeight, distY, bgHeight)
    end
    
    for i=1, secondColCount do
        ret[#ret + 1] = {};
        ret[#ret]["x"] = CALC_CENTER_ALIGN_POSITION(i, secondColCount, cardWidth, distX, bgWidth)
        ret[#ret]["y"] = CALC_CENTER_ALIGN_POSITION(2, rowCount, cardHeight, distY, bgHeight)
    end

    return ret;
end

function GET_JOB_SELECT_GUIDE_PAGE_COUNT(jobCount, countPerPage)
    local pageCount = math.ceil(jobCount / countPerPage);
    return pageCount;
end

function GET_JOB_SELECT_GUIDE_RESULT_COUNT_PER_PAGE(jobCount, pageIndex, countPerPage)
    local pageCount = GET_JOB_SELECT_GUIDE_PAGE_COUNT(jobCount, countPerPage);

    local isLastPage = pageCount == pageIndex;
    if isLastPage == true then
        local lastPageElemCount = jobCount % countPerPage;
        if lastPageElemCount == 0 then
            lastPageElemCount = countPerPage;
        end
        return lastPageElemCount;
    else
        return countPerPage;
    end
end

function GET_SELECT_GUIDE_JOB_CLASS_NAME(jobList, pageIndex, countPerPage, elemIndex)
    local jobClsName = jobList[(pageIndex-1)*countPerPage+elemIndex];
    if jobClsName == nil then
        IMC_LOG("INFO_NORMAL", tostring((pageIndex-1)*countPerPage+elemIndex));
    end
    return jobClsName;
end

function PARSE_JOB_SELECT_GUIDE_RANKING(str)
    local tokenList  = TokenizeByChar(str, ";");
    local jobHash = {}

    for i = 1, #tokenList do
        local token = tokenList[i]
        if jobHash[token] == nil then
            jobHash[token] = 1;
        else
            jobHash[token] = jobHash[token] + 1;
        end
    end
    
    local sortedJob = {}
    for i, v in pairs(jobHash) do
        sortedJob[#sortedJob + 1] = {ClassName=i, Circle=v}
    end
    
    table.sort(sortedJob, JOB_SELECT_GUIDE_SORT_JOB_IN_TREE)
    return sortedJob;
end

function JOB_SELECT_GUIDE_SORT_JOB_IN_TREE(a, b)
    local jobA = a["ClassName"]
    local jobB = b["ClassName"]

    local jobClsA = GetClass("Job", jobA)
    local jobClsB = GetClass("Job", jobB)

    if jobClsA.Rank == jobClsB.Rank then
        return jobClsA.ClassID < jobClsB.ClassID
    end

	return jobClsA.Rank < jobClsB.Rank
end
