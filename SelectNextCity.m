function j = SelectNextCity(P)

    r = rand;
    C = cumsum(P);
    j = find(r <= C, 1, 'first');
end
