--Populatong Dimensions
INSERT INTO dim_customers 
SELECT DISTINCT customer_id, customer_fname, customer_lname, customer_city, customer_state, customer_country, customer_zipcode, customer_segment FROM supply_chain_orders;

INSERT INTO dim_products 
SELECT DISTINCT product_card_id, product_category_id, category_name, product_name, product_description, product_price, product_status FROM supply_chain_orders;

INSERT INTO dim_location (market, region, country, state, city)
SELECT DISTINCT market, order_region, order_country, order_state, order_city FROM supply_chain_orders;

--Populating Fact Table
INSERT INTO fact_sales (
    order_item_id, order_id, date_key, customer_id, location_id, product_id, 
    quantity, revenue, net_revenue, discount, profit_ratio, discount_ratio, 
    late_delivery_risk, days_for_shipping_real, days_for_shipping_scheduled
)
SELECT DISTINCT ON (s.order_item_id)
    s.order_item_id, s.order_id, s.shipping_date_dateorders::DATE, s.customer_id, l.location_id, s.product_card_id,
    s.order_item_quantity, s.sales, s.order_item_total, s.order_item_discount, s.order_item_profit_ratio, s.order_item_discount_rate,
    s.late_delivery_risk, s.days_for_shipping_real, s.days_for_shipment_scheduled
FROM supply_chain_orders s
JOIN dim_location l ON s.order_city = l.city AND s.order_state = l.state;

--updating country and city names(English Equivalent)
UPDATE dim_location
SET country = CASE country
    WHEN 'Estados Unidos' THEN 'United States'
    WHEN 'Costa de Marfil' THEN 'Ivory Coast'
    WHEN 'Benín' THEN 'Benin'
    WHEN 'Níger' THEN 'Niger'
    WHEN 'Sáhara Occidental' THEN 'Western Sahara'
    WHEN 'República de Gambia' THEN 'Gambia'
    WHEN 'Túnez' THEN 'Tunisia'
    WHEN 'Libia' THEN 'Libya'
    WHEN 'Sudán' THEN 'Sudan'
    WHEN 'Argelia' THEN 'Algeria'
    WHEN 'Marruecos' THEN 'Morocco'
    WHEN 'Egipto' THEN 'Egypt'
    WHEN 'Kenia' THEN 'Kenya'
    WHEN 'Zimbabue' THEN 'Zimbabwe'
    WHEN 'Ruanda' THEN 'Rwanda'
    WHEN 'Etiopía' THEN 'Ethiopia'
    WHEN 'Yibuti' THEN 'Djibouti'
    WHEN 'Sudán del Sur' THEN 'South Sudan'
    WHEN 'República Centroafricana' THEN 'Central African Republic'
    WHEN 'Gabón' THEN 'Gabon'
    WHEN 'República del Congo' THEN 'Republic of the Congo'
    WHEN 'Chad' THEN 'Chad'
    WHEN 'Guinea Ecuatorial' THEN 'Equatorial Guinea'
    WHEN 'República Democrática del Congo' THEN 'Democratic Republic of the Congo'
    WHEN 'Lesoto' THEN 'Lesotho'
    WHEN 'Botsuana' THEN 'Botswana'
    WHEN 'Suazilandia' THEN 'Eswatini'
    WHEN 'SudAfrica' THEN 'South Africa'
    WHEN 'Canadá' THEN 'Canada'
    WHEN 'Trinidad y Tobago' THEN 'Trinidad and Tobago'
    WHEN 'Haití' THEN 'Haiti'
    WHEN 'Guadalupe' THEN 'Guadeloupe'
    WHEN 'República Dominicana' THEN 'Dominican Republic'
    WHEN 'Perú' THEN 'Peru'
    WHEN 'Guayana Francesa' THEN 'French Guiana'
    WHEN 'Brasil' THEN 'Brazil'
    WHEN 'Panamá' THEN 'Panama'
    WHEN 'México' THEN 'Mexico'
    WHEN 'Tailandia' THEN 'Thailand'
    WHEN 'Vietnam' THEN 'Vietnam'
    WHEN 'Singapur' THEN 'Singapore'
    WHEN 'Myanmar (Birmania)' THEN 'Myanmar'
    WHEN 'Laos' THEN 'Laos'
    WHEN 'Camboya' THEN 'Cambodia'
    WHEN 'Filipinas' THEN 'Philippines'
    WHEN 'Malasia' THEN 'Malaysia'
    WHEN 'Arabia Saudí' THEN 'Saudi Arabia'
    WHEN 'Georgia' THEN 'Georgia'
    WHEN 'Yemen' THEN 'Yemen'
    WHEN 'Kuwait' THEN 'Kuwait'
    WHEN 'Jordania' THEN 'Jordan'
    WHEN 'Siria' THEN 'Syria'
    WHEN 'Líbano' THEN 'Lebanon'
    WHEN 'Emiratos Árabes Unidos' THEN 'United Arab Emirates'
    WHEN 'Azerbaiyán' THEN 'Azerbaijan'
    WHEN 'Omán' THEN 'Oman'
    WHEN 'Baréin' THEN 'Bahrain'
    WHEN 'Armenia' THEN 'Armenia'
    WHEN 'Irak' THEN 'Iraq'
    WHEN 'Turquía' THEN 'Turkey'
    WHEN 'Irán' THEN 'Iran'
    WHEN 'Pakistán' THEN 'Pakistan'
    WHEN 'Bangladés' THEN 'Bangladesh'
    WHEN 'Afganistán' THEN 'Afghanistan'
    WHEN 'Bután' THEN 'Bhutan'
    WHEN 'Japón' THEN 'Japan'
    WHEN 'Kazajistán' THEN 'Kazakhstan'
    WHEN 'Kirguistán' THEN 'Kyrgyzstan'
    WHEN 'Uzbekistán' THEN 'Uzbekistan'
    WHEN 'Turkmenistán' THEN 'Turkmenistan'
    WHEN 'Tayikistán' THEN 'Tajikistan'
    WHEN 'Papúa Nueva Guinea' THEN 'Papua New Guinea'
    WHEN 'Nueva Zelanda' THEN 'New Zealand'
    WHEN 'India' THEN 'India'
    WHEN 'China' THEN 'China'
    WHEN 'Australia' THEN 'Australia'
    WHEN 'Ucrania' THEN 'Ukraine'
    WHEN 'Rusia' THEN 'Russia'
    WHEN 'Polonia' THEN 'Poland'
    WHEN 'Rumania' THEN 'Romania'
    WHEN 'Bielorrusia' THEN 'Belarus'
    WHEN 'República Checa' THEN 'Czech Republic'
    WHEN 'Bulgaria' THEN 'Bulgaria'
    WHEN 'Hungría' THEN 'Hungary'
    WHEN 'Moldavia' THEN 'Moldova'
    WHEN 'Eslovaquia' THEN 'Slovakia'
    WHEN 'Serbia' THEN 'Serbia'
    WHEN 'Lituania' THEN 'Lithuania'
    WHEN 'Reino Unido' THEN 'United Kingdom'
    WHEN 'Irlanda' THEN 'Ireland'
    WHEN 'Finlandia' THEN 'Finland'
    WHEN 'Estonia' THEN 'Estonia'
    WHEN 'Suecia' THEN 'Sweden'
    WHEN 'Dinamarca' THEN 'Denmark'
    WHEN 'Noruega' THEN 'Norway'
    WHEN 'Portugal' THEN 'Portugal'
    WHEN 'Croacia' THEN 'Croatia'
    WHEN 'Grecia' THEN 'Greece'
    WHEN 'Bosnia y Herzegovina' THEN 'Bosnia and Herzegovina'
    WHEN 'Montenegro' THEN 'Montenegro'
    WHEN 'Albania' THEN 'Albania'
    WHEN 'Eslovenia' THEN 'Slovenia'
    WHEN 'Chipre' THEN 'Cyprus'
    WHEN 'Macedonia' THEN 'North Macedonia'
    WHEN 'España' THEN 'Spain'
    WHEN 'Italia' THEN 'Italy'
    WHEN 'Países Bajos' THEN 'Netherlands'
    WHEN 'Bélgica' THEN 'Belgium'
    WHEN 'Suiza' THEN 'Switzerland'
    WHEN 'Luxemburgo' THEN 'Luxembourg'
    WHEN 'Austria' THEN 'Austria'
    WHEN 'Alemania' THEN 'Germany'
    WHEN 'Francia' THEN 'France'
    ELSE country
END;

--cities
UPDATE dim_location
SET city = CASE city
    WHEN 'Dublín' THEN 'Dublin'
    WHEN 'Pekín' THEN 'Beijing'
    WHEN 'Shanghái' THEN 'Shanghai'
    WHEN 'Viena' THEN 'Vienna'
    WHEN 'Berlín' THEN 'Berlin'
    WHEN 'Colonia' THEN 'Cologne'
    WHEN 'Estambul' THEN 'Istanbul'
    WHEN 'Teherán' THEN 'Tehran'
    WHEN 'Seúl' THEN 'Seoul'
    WHEN 'Tokio' THEN 'Tokyo'
    WHEN 'Varsovia' THEN 'Warsaw'
    WHEN 'Praga' THEN 'Prague'
    WHEN 'Brujas' THEN 'Bruges'
    WHEN 'Bruselas' THEN 'Brussels'
    WHEN 'Amberes' THEN 'Antwerp'
    WHEN 'Luxemburgo' THEN 'Luxembourg'
    WHEN 'Moscú' THEN 'Moscow'
    WHEN 'Ciudad de México' THEN 'Mexico City'
    WHEN 'El Cairo' THEN 'Cairo'
    WHEN 'Ginebra' THEN 'Geneva'
    WHEN 'Florencia' THEN 'Florence'
    WHEN 'Nápoles' THEN 'Naples'
    WHEN 'Venecia' THEN 'Venice'
    ELSE city
END;

ALTER TABLE fact_sales
ADD COLUMN location_id INTEGER;

UPDATE fact_sales f
SET location_id = l.location_id
FROM supply_chain_orders s
JOIN dim_location l
    ON s.market = l.market
   AND s.order_region = l.region
   AND s.order_country = l.country
   AND s.order_state = l.state
   AND s.order_city = l.city
WHERE f.order_item_id = s.order_item_id;

ALTER TABLE fact_sales
ADD CONSTRAINT fk_location
FOREIGN KEY (location_id)
REFERENCES dim_location(location_id);

SELECT *
FROM
fact_sales 
LIMIT 10;