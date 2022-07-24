class('MarkovChain').extends()

function MarkovChain:initialize(sourceFile)
    local file = playdate.file.open(sourceFile, playdate.file.kFileRead)
    if not file then return nil end

    local names = {}
    for token in string.gmatch(file:read(1000000), "[^\n]+") do 
        names[#names+1] = string.lower(token)
    end
    file:close()

    self.chain = build_markov_chain(names,5)
end

function MarkovChain:init(type)
    if type == 'stellar' then
        MarkovChain:initialize('data/stellar.txt')
    elseif type == 'names' then
        MarkovChain:initialize('data/names.txt')
    end
end

function MarkovChain:generate()
    return generate(self.chain)
end

function build_markov_chain(data, n)
    chain = {}
    chain._initial = {}
    chain._names = data

    for _, word in pairs(data) do
        word_wrapped = word .. '.'
        for i = 1, #word_wrapped - n + 1 do
            prefix = string.sub(word_wrapped, i, i+n)
            suffix = string.sub(word_wrapped, i+1, i+n+1)

            if chain[prefix] == nil then
                chain[prefix] = {}
            end
            entry = chain[prefix]

            if i == 1 then
                if chain._initial[prefix] == nil then
                    chain._initial[prefix] = 1
                else
                    chain._initial[prefix] = chain._initial[prefix] + 1
                end
            end

            if entry[suffix] == nil then
                entry[suffix] = 1
            else
                entry[suffix] = entry[suffix] + 1
            end
        end
    end

    return chain
end

function select_random_item(items)
    local chain_sum = 0
    
    for _, v in pairs(items) do
        chain_sum = chain_sum + v
    end
    rnd = math.random() * chain_sum
    
    for k, v in pairs(items) do
        rnd = rnd - v
        if rnd < 0 then
            return k
        end
    end
end

function generate(inner_chain)
    local prefix = select_random_item(inner_chain._initial)

    last_character = string.sub(prefix,#prefix)
    if last_character == '.' then
        prefix = string.sub(prefix, 1, #prefix-1)
    end

    result = { prefix }

    while true do
        if inner_chain[prefix] == nil then break end
        
        prefix = select_random_item(inner_chain[prefix])
        
        if prefix == nil then break end

        last_character = string.sub(prefix,#prefix)
        if last_character == '.' then
            break
        end
        result[#result+1] = last_character
    end

    generated = table.concat(result, '')

    if inner_chain._names[generated] == nil then
        return generated
    else
        return generate(inner_chain)
    end
end