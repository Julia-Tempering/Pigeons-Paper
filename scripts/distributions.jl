function target_pdf(x, y, a)
    return 0.5 * (pdf(Normal(-a, 1.0), x) * pdf(Normal(-a, 1.0), y)) +
           0.5 * (pdf(Normal(a, 1.0), x) * pdf(Normal(a, 1.0), y))
end

function reference_pdf(x, y, a)
    return pdf(Normal(0.0, sqrt(a^2+1)), x) * pdf(Normal(0.0, sqrt(a^2+1)), y)
end

